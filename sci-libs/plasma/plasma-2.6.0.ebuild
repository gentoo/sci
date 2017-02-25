# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils fortran-2 toolchain-funcs versionator multilib flag-o-matic

MYP=${PN}_${PV}
SOVER=$(get_version_component_range 1)

DESCRIPTION="Parallel Linear Algebra for Scalable Multi-core Architecture"
HOMEPAGE="http://icl.cs.utk.edu/plasma/"
SRC_URI="http://icl.cs.utk.edu/projectsfiles/plasma/pubs/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0/${SOVER}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples fortran static-libs test"

RDEPEND="
	sys-apps/hwloc
	virtual/blas
	virtual/cblas
	virtual/lapack
	virtual/lapacke"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sci-libs/lapacke-reference[tmg] )"

S="${WORKDIR}/${MYP}"

# TODO: virtual/{blas,cblas,lapack} serial and threaded. plasma works properly
# with serial blas/lapack (see README). not doable dynamically with atlas

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname ${SOVER})
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

src_prepare() {
	# rename plasma to avoid collision (https://github.com/gentoo-science/sci/issues/34)
	# lib name conflict with kde plasma, rename
	PLASMA_LIBNAME=plasmca
	sed -i \
		-e "s/-lplasma/-l${PLASMA_LIBNAME}/g" \
		-e "s/libplasma.a/lib${PLASMA_LIBNAME}.a/" \
		Makefile.internal || die

	# distributed pc file not so useful, so redo it
	cat <<-EOF > ${PN}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/${PN}
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${PLASMA_LIBNAME} -lcoreblas -lquark
		Libs.private: -lm
		Cflags: -I\${includedir}
		Requires: blas cblas lapack lapacke hwloc
	EOF
}

src_configure() {
	cat <<-EOF > make.inc
		ARCH = $(tc-getAR)
		ARCHFLAGS = cr
		RANLIB = $(tc-getRANLIB)
		CC = $(tc-getCC)
		FC = $(tc-getFC)
		CFLAGS = ${CFLAGS} -DADD_ -fPIC $(has_version ">=virtual/lapacke-3.5" && echo "-DDOXYGEN_SHOULD_SKIP_THIS=1")
		FFLAGS = ${FFLAGS} -fPIC
		LOADER = $(tc-getFC)
		LIBBLAS = $($(tc-getPKG_CONFIG) --libs blas)
		LIBCBLAS = $($(tc-getPKG_CONFIG) --libs cblas)
		LIBLAPACK = $($(tc-getPKG_CONFIG) --libs lapack) -ltmglib
		LIBCLAPACK = $($(tc-getPKG_CONFIG) --libs lapacke)
		$(use fortran && echo "PLASMA_F90 = 1")
	EOF
}

src_compile() {
	emake lib
	#mv lib/libplasma.a lib/lib${PLASMA_LIBNAME}.a || die
	static_to_shared quark/libquark.a $($(tc-getPKG_CONFIG --libs hwloc)) -pthread
	static_to_shared lib/libcoreblas.a quark/libquark.so $($(tc-getPKG_CONFIG --libs cblas lapacke))
	static_to_shared lib/lib${PLASMA_LIBNAME}.a quark/libquark.so lib/libcoreblas.so
	if use static-libs; then
		emake cleanall
		sed 's/-fPIC//g' make.inc
		emake lib
	fi
}

src_test() {
	emake test
	cd testing
	LD_LIBRARY_PATH="../lib:../quark:${LD_LIBRARY_PATH}" ./plasma_testing.py || die
}

src_install() {
	dolib.so lib/lib*$(get_libname)* quark/libquark$(get_libname)*
	use static-libs && dolib.a lib/lib*.a quark/libquark.a
	insinto /usr/include/${PN}
	doins quark/quark{,_unpack_args}.h quark/icl_{hash,list}.h include/*.h
	use fortran && doins include/*.mod
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	dodoc README ToDo ReleaseNotes
	use doc && dodoc docs/pdf/*.pdf && dohtml docs/doxygen/out/html/*
	if use examples; then
		emake -C examples cleanall
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	elog "The plasma linear algebra library file has been renamed ${PLASMA_LIBNAME}"
	elog "to avoid collision with KDE plasma."
	elog "Compile and link your programs using the following command:"
	elog "     pkg-config --cflags --libs plasma"
}
