# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils fortran-2 toolchain-funcs versionator

MYP=${PN}_${PV}

DESCRIPTION="Parallel Linear Algebra for Scalable Multi-core Architecture"
HOMEPAGE="http://icl.cs.utk.edu/plasma/"
SRC_URI="http://icl.cs.utk.edu/projectsfiles/plasma/pubs/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples fortran static-libs"

RDEPEND="sys-apps/hwloc
	virtual/blas
	virtual/cblas
	virtual/lapack
	virtual/lapacke"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MYP}"

make_shared_lib() {
	local libstatic=${1}
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	shift
	einfo "Making ${soname}"
	${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
		"$@" -o $(dirname "${libstatic}")/"${soname}" \
		|| die "${soname} failed"
	ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
}

src_prepare() {
	# distributed pc file not so useful
	cat <<-EOF > ${PN}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/${PN}
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lplasma -lcoreblas -lquark
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
		CFLAGS = ${CFLAGS} -DADD_ -fPIC
		FFLAGS = ${FFLAGS} -fPIC
		LOADER = $(tc-getFC)
		LIBBLAS = $(pkg-config --libs blas)
		LIBCBLAS = $(pkg-config --libs cblas)
		LIBLAPACK = $(pkg-config --libs lapack)
		LIBCLAPACK = $(pkg-config --libs lapacke)
		$(use fortran && echo "PLASMA_F90 = 1")
	EOF
}

src_compile() {
	emake lib
	make_shared_lib quark/libquark.a $(pkg-config --libs hwloc) -pthread
	make_shared_lib lib/libcoreblas.a quark/libquark.so $(pkg-config --libs cblas lapacke)
	make_shared_lib lib/libplasma.a quark/libquark.so lib/libcoreblas.so
	if use static-libs; then
		emake cleanall
		sed 's/-fPIC//g' make.inc
		emake lib
	fi
}

src_install() {
	dolib.so lib/lib*.so* quark/libquark.so*
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
