# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs fortran multilib

DESCRIPTION="Automatically Tuned Linear Algebra Software BLAS implementation"
HOMEPAGE="http://math-atlas.sourceforge.net/"
MY_PN=${PN/blas-/}
SRC_URI="mirror://sourceforge/math-atlas/${MY_PN}${PV}.tar.bz2"
#		mirror://gentoo/${MY_PN}-${PV}-shared-libs.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

RDEPEND="app-admin/eselect-blas
	app-admin/eselect-cblas
	dev-util/pkgconfig
	doc? ( app-doc/blas-docs )"

DEPEND="app-admin/eselect-blas
	app-admin/eselect-cblas
	>=sys-devel/libtool-1.5"

S="${WORKDIR}/ATLAS"
BLD_DIR="${S}/gentoo-build"
RPATH="${DESTTREE}/$(get_libdir)/blas"

pkg_setup() {
	# icc won't compile (as of icc-10.0.025)
	# and will blow out $PORTAGE_TMPDIR
	if [[ $(tc-getCC) = icc* ]]; then
		eerror "icc compiler is not supported with sci-libs/blas-atlas"
		die "blas-atlas won't compile with icc"
	fi

	FORTRAN="g77 gfortran ifc"
	fortran_pkg_setup
	echo
	ewarn "Please make sure to disable CPU throttling completely"
	ewarn "during the compile of blas-atlas. Otherwise, all atlas"
	ewarn "generated timings will be completely random and the"
	ewarn "performance of the resulting libraries will be degraded"
	ewarn "considerably."
	echo
	ewarn "For users of <=gcc-4.1.1 only:"
	ewarn "If you experience failing SANITY tests during"
	ewarn "atlas' compile please try passing -mfpmath=387; this"
	ewarn "option might also result in much better performance"
	ewarn "than using then sse instruction set depending on your"
	ewarn "CPU."
	echo
	epause 10
}

src_unpack() {
	unpack ${A}
	cd ${S}

	#epatch "${DISTDIR}"/${MY_PN}-${PV}-shared-libs.patch.bz2
	epatch "${FILESDIR}"/${MY_PN}-${PV}-shared-libs.patch
	epatch "${FILESDIR}"/${MY_PN}-asm-gentoo.patch

	# increase amount of workspace to improve threaded performance
	sed -e "s:16777216:167772160:" -i include/atlas_lvl3.h || \
		die "Failed to fix ATL_MaxMalloc"

	sed -e "s:= gcc:= $(tc-getCC) ${CFLAGS}:" \
		-i CONFIG/src/SpewMakeInc.c || die "Failed to fix Spewmake"

	mkdir ${BLD_DIR}  || die "failed to generate build directory"
	cd ${BLD_DIR}
	cp "${FILESDIR}"/war . && chmod a+x war || \
		die "failed to install war"

	local archselect
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "ppc64" ]]; then
		archselect="-b 64"
	elif [ "${ARCH}" == "alpha" ]; then
		archselect=""
	else
		archselect="-b 32"
	fi

    ../configure \
		--cc="$(tc-getCC)" \
        --cflags="${CFLAGS}" \
        --prefix="${D}/${DESTTREE}" \
        --libdir="${D}/${DESTTREE}/$(get_libdir)/atlas" \
        --incdir="${D}/${DESTTREE}/include" \
        -C ac "$(tc-getCC)" -F ac "${CFLAGS}" \
        -C if "${FORTRANC}" -F if "${FFLAGS}" \
        -Ss pmake "\$(MAKE) ${MAKEOPTS}" \
        -Si cputhrchk 0 ${archselect} \
        || die "configure failed"


}

src_compile() {
	cd ${BLD_DIR}
	emake -j1 || die "emake failed"

	make shared LIBDIR="$(get_libdir)" RPATH="${RPATH}/atlas" || \
		die "failed to build shared libraries"

	# build shared libraries of threaded libraries if applicable
	if [ -d gentoo/libptcblas.a ]; then
		make ptshared LIBDIR="$(get_libdir)" RPATH="${RPATH}/threaded-atlas" || \
			die "failed to build threaded shared libraries"
	fi
}

src_test() {
	# make check does not work because
	# we don't build lapack libs
	for i in F77 C; do
		einfo "Testing ${i} interface"
		cd ${BLD_DIR}/interfaces/blas/${i}/testing
		make sanity_test || die "make tests for ${i} failed"
		if [ -d ${BLD_DIR}/gentoo/libptf77blas.a ]; then
			make ptsanity_test || die "make tests threaded for ${i}failed"
		fi
	done
	echo "Timing ATLAS"
	cd ${BLD_DIR}
	make time || die "make time failed"
}

src_install () {
	dodir "${RPATH}"/atlas
	cd ${BLD_DIR}/gentoo/libs
	cp -P libatlas* "${D}/${DESTTREE}/$(get_libdir)" || \
		die "Failed to install libatlas"

	# pkgconfig files
	local extlibs="-lm"
	local threadlibs
	[[ ${FORTRANC} == "gfortran" ]] && extlibs="${extlibs} -lgfortran"
	[[ ${FORTRANC} == "g77" ]] && extlibs="${extlibs} -lg2c"
	cp "${FILESDIR}"/blas.pc.in blas.pc
	cp "${FILESDIR}"/cblas.pc.in cblas.pc
	sed -i \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PV@:${PV}:" \
		-e "s:@EXTLIBS@:${extlibs}:g" \
		-e "s:@THREADLIBS@:${threadlibs}:g" \
		*blas.pc || die "sed *blas.pc failed"

	cp -P *blas* "${D}/${RPATH}"/atlas || \
		die "Failed to install blas/cblas"
	eselect blas add $(get_libdir) "${FILESDIR}"/eselect.blas.atlas atlas
	eselect cblas add $(get_libdir) "${FILESDIR}"/eselect.cblas.atlas atlas

	if [ -d ${BLD_DIR}/gentoo/threaded-libs ]
	then
		dodir "${RPATH}"/threaded-atlas
		cd ${BLD_DIR}/gentoo/threaded-libs

		# pkgconfig files
		cp ${FILESDIR}/blas.pc.in blas.pc
		cp ${FILESDIR}/cblas.pc.in cblas.pc
		threadlibs="-lpthread"
		sed -i \
			-e "s:@LIBDIR@:$(get_libdir):" \
			-e "s:@PV@:${PV}:" \
			-e "s:@EXTLIBS@:${extlibs}:g" \
			-e "s:@THREADLIBS@:${threadlibs}:g" \
			*blas.pc || die "sed *blas.pc failed"

		cp -P * "${D}/${RPATH}"/threaded-atlas || \
			die "Failed to install threaded atlas"
		eselect blas add $(get_libdir) "${FILESDIR}"/eselect.blas.threaded-atlas threaded-atlas
		eselect cblas add $(get_libdir) "${FILESDIR}"/eselect.cblas.threaded-atlas threaded-atlas
	fi

	insinto "${DESTTREE}"/include/atlas
	doins "${S}"/include/cblas.h "${S}"/include/atlas_misc.h \
		"${S}"/include/atlas_enum.h || \
		die "failed to install headers"

	# These headers contain the architecture-specific
	# optimizations determined by ATLAS. The atlas-lapack build
	# is much shorter if they are available, so save them:
	doins ${BLD_DIR}/include/*.h || \
		die "failed to install timing headers"

	# some docs
	cd "${S}"/doc
	dodoc INDEX.txt AtlasCredits.txt ChangeLog || die "dodoc failed"
	# atlas specific doc (blas generic docs installed by blas-docs)
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins atlas*pdf cblasqref.pdf || die "doins docs failed"
	fi
}

pkg_postinst() {
	local THREADED
	[ -f "${RPATH}"/threaded-atlas/libcblas.a ] && THREADED="threaded-"
	[[ -z "$(eselect blas show)" ]] && eselect blas set ${THREADED}atlas
	[[ -z "$(eselect cblas show)" ]] && eselect cblas set ${THREADED}atlas

	elog "Use 'eselect blas' and 'eselect cblas' (as root) to select"
	elog "one of the ATLAS blas and cblas profiles."
	elog "Use 'pkg-config --libs blas' to link with ATLAS blas."
	elog "Use 'pkg-config --cflags cblas' and 'pkg-config --libs cblas'"
	elog "to compile and link with ATLAS cblas"
}
