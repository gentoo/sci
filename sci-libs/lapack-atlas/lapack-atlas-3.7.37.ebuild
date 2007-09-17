# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs fortran autotools versionator

MY_PN="${PN/lapack-/}"
L_PN="lapack"
L_PV="3.1.1"
BlasRelease=$(get_version_component_range 1-3)

DESCRIPTION="F77 and C LAPACK implementations using available ATLAS routines"
LICENSE="BSD"
HOMEPAGE="http://math-atlas.sourceforge.net/"
SRC_URI1="mirror://sourceforge/math-atlas/${MY_PN}${PV}.tar.bz2"
SRC_URI2="http://www.netlib.org/${L_PN}/${L_PN}-lite-${L_PV}.tgz"
SRC_URI="${SRC_URI1} ${SRC_URI2}"
#	mirror://gentoo/${MY_PN}-${PV}-shared-libs.patch.bz2"

SLOT="0"
IUSE="doc"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="virtual/blas
	virtual/cblas
	app-admin/eselect-lapack
	~sci-libs/blas-atlas-${BlasRelease}
	>=sys-devel/libtool-1.5"

RDEPEND="${DEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/lapack-docs )"

FORTRAN="g77 gfortran ifc"

S="${WORKDIR}/ATLAS"
S_LAPACK="${WORKDIR}/${L_PN}-lite-${L_PV}"
BLD_DIR="${S}/gentoo-build"
RPATH="${DESTTREE}/$(get_libdir)/${L_PN}/${MY_PN}"

src_unpack() {
	unpack ${A}

	#epatch "${DISTDIR}"/${MY_PN}-${PV}-shared-libs.patch.bz2
	epatch "${FILESDIR}"/${MY_PN}-${PV}-shared-libs.patch
	epatch "${FILESDIR}"/${MY_PN}-asm-gentoo.patch

	cd "${S}"
	mkdir ${BLD_DIR}  || die "failed to generate build directory"
	cp "${FILESDIR}"/war "${BLD_DIR}" && chmod a+x "${BLD_DIR}"/war \
		|| die "failed to install war"

	# make sure the compile picks up the proper includes
	sed -e "s|INCLUDES =|INCLUDES = -I/usr/include/atlas/|"  \
		-e "s:= gcc:= $(tc-getCC) ${CFLAGS}:"  \
		-i CONFIG/src/SpewMakeInc.c || \
		die "failed to append proper includes"

	# force proper 32/64bit libs
	local archselect
	if [[ "${ARCH}" == "amd64" || "${ARCH}" == "ppc64" ]]; then
		archselect="-b 64"
	elif [ "${ARCH}" == "alpha" ]; then
		archselect=""
	else
		archselect="-b 32"
	fi

	cd ${BLD_DIR} && ../configure \
		--cc=$(tc-getCC) \
		--cflags="${CFLAGS}" \
		--prefix=${D}/${DESTTREE} \
		--libdir=${D}/${DESTTREE}/$(get_libdir)/atlas \
		--incdir=${D}/${DESTTREE}/include \
		-C ac "$(tc-getCC)" -F ac "${CFLAGS}" \
		-C if "${FORTRANC}" -F if "${FFLAGS:--O2}" \
		-Ss pmake "\$(MAKE) ${MAKEOPTS}" \
		-Si cputhrchk 0 ${archselect} \
		|| die "configure failed"

	cd "${S_LAPACK}"
	epatch "${FILESDIR}"/${L_PN}-reference-${L_PV}-autotool.patch
	epatch "${FILESDIR}"/${L_PN}-reference-${L_PV}-test-fix.patch
	eautoreconf

	# set up the testing routines
	sed -e "s:g77:${FORTRANC}:" \
		-e "s:-funroll-all-loops -O3:${FFLAGS} $(pkg-config --cflags blas cblas):" \
		-e "s:LOADOPTS =:LOADOPTS = ${LDFLAGS} $(pkg-config --cflags blas cblas):" \
		-e "s:../../blas\$(PLAT).a:$(pkg-config --libs blas cblas):" \
		-e "s:lapack\$(PLAT).a:SRC/.libs/liblapack.so:" \
		-e "s:EXT_ETIME$:INT_CPU_TIME:" \
		make.inc.example > make.inc \
		|| die "Failed to set up make.inc"
}

src_compile() {
	# build atlas' part of lapack
	cd "${BLD_DIR}"
	for d in src/lapack interfaces/lapack/C/src interfaces/lapack/F77/src; do
		cd "${BLD_DIR}/${d}"
		make lib || die "Failed to make lib in ${d}"
	done

	# build rest of lapack
	cd "${S_LAPACK}"
	econf || die "Failed to configure reference lapack lib"
	emake || die "Failed to make reference lapack lib"

	cd "${S_LAPACK}"/SRC
	einfo "Copying liblapack.a/*.o to ${S_LAPACK}/SRC"
	cp -sf "${BLD_DIR}"/gentoo/liblapack.a/*.o .
	einfo "Copying liblapack.a/*.lo to ${S_LAPACK}/SRC"
	cp -sf "${BLD_DIR}"/gentoo/liblapack.a/*.lo .
	einfo "Copying liblapack.a/.libs/*.o to ${S_LAPACK}/SRC"
	cp -sf "${BLD_DIR}"/gentoo/liblapack.a/.libs/*.o .libs/

	local flibs
	[[ ${FORTRANC} == "gfortran" ]] && flibs="-lgfortran"
	[[ ${FORTRANC} == "g77" ]] && flibs="-lg2c"
	../libtool --mode=link --tag=F77 ${FORTRANC} \
		$(pkg-config --libs blas cblas) -latlas ${flibs} \
		-o liblapack.la *.lo -rpath "${RPATH}" \
		|| die "Failed to create liblapack.la"

	# making pkg-config file
	sed -e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PV@:${PV}:" \
		-e "s:@EXTLIBS@:-lm ${flibs}:g" \
		"${FILESDIR}/lapack.pc.in" > "${S}"/lapack.pc \
		|| die "sed lapack.pc failed"
}

src_install () {
	dodir "${RPATH}"

	cd "${S_LAPACK}"/SRC
	../libtool --mode=install cp liblapack.la "${D}/${RPATH}" \
		|| die "Failed to install lapack-atlas library"

	eselect lapack add $(get_libdir) "${FILESDIR}"/eselect.lapack.atlas atlas

	insinto /usr/include/atlas
	doins "${S}"/include/clapack.h || die "Failed to install clapack.h"

	cd "${S}"
	dodoc README doc/AtlasCredits.txt doc/ChangeLog || \
		die "Failed to install docs"

	insinto /usr/$(get_libdir)/lapack/atlas
	doins "${S}"/lapack.pc || die "Failed to install lapack.pc"
}

src_test() {
	cd "${S_LAPACK}"/TESTING/MATGEN && emake || \
		die "Failed to create tmglib.a"
	cd ../ && emake || die "lapack-reference tests failed."
}

pkg_postinst() {
	[[ -z "$(eselect lapack show)" ]] && eselect lapack set atlas

	elog "Use 'eselect lapack' (as root) to select"
	elog "one of the ATLAS lapack profiles."
	elog "Once selected, use 'pkg-config --libs lapack' to link with ATLAS lapack."
	elog "With C, add  'pkg-config --cflags lapack' to compile."
}
