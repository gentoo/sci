# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools
inherit cmake distutils-r1 toolchain-funcs

GTS_HASH="962155a01f5a1b87bd64e3e3d880b4dbc2347ac7"
NIFTI_HASH="da476fd27f46098f37f5c9c4c1baee01e559572c"
GIFTI_HASH="d3e873d8539d9b469daf7db04093da1d7e73d4f7"

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="http://stnava.github.io/ANTs/"
SRC_URI="
	https://github.com/afni/afni/archive/refs/tags/AFNI_${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/NIFTI-Imaging/nifti_clib/archive/${NIFTI_HASH}.tar.gz -> nifti-${NIFTI_HASH}.tar.gz
	https://github.com/NIFTI-Imaging/gifti_clib/archive/${GIFTI_HASH}.tar.gz -> gifti-${GIFTI_HASH}.tar.gz
	"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="test whirlgif"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libf2c
	dev-libs/expat
	dev-build/ninja
	media-libs/freeglut
	media-libs/glu
	media-libs/netpbm
	media-libs/qhull
	media-video/mpeg-tools
	sci-libs/gsl
	sci-libs/gts
	sys-devel/llvm:*
	sys-libs/libomp
	dev-libs/libpthread-stubs
	virtual/jpeg-compat:62
	x11-libs/libGLw
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	x11-libs/motif[-static-libs]
	"
DEPEND="
	${RDEPEND}
	app-shells/tcsh
	"
# Prospectively:
#Update jpeg-compat to virtual/jpeg:0
# look for xmhtlm

S="${WORKDIR}/afni-AFNI_${PV}"

	#tar xf "${DISTDIR}/${GTS_HASH}.tar.gz" || die
src_prepare() {
	tar xf "${DISTDIR}/nifti-${NIFTI_HASH}.tar.gz" || die
	tar xf "${DISTDIR}/gifti-${GIFTI_HASH}.tar.gz" || die
	cmake_src_prepare
	default
	}

src_configure() {
	if use !whirlgif; then
		eapply "${FILESDIR}/${PN}-24.0.04-whirlgif.patch"
	fi
	export CFLAGS="-pthread ${CFLAGS}"
	export GIT_REPO_VERSION=3.0.1.1
	local mycmakeargs=(
		-DLIBDIR=/usr/$(get_libdir)
		-DNIFTI_INSTALL_LIBRARY_DIR=/usr/$(get_libdir)
		-DGIFTI_INSTALL_LIBRARY_DIR=/usr/$(get_libdir)
		-DGIFTI_INSTALL_LIB_DIR=/usr/$(get_libdir)
		-DAFNI_INSTALL_LIBRARY_DIR=/usr/$(get_libdir)
		-DCMAKE_INSTALL_LIBDIR=/usr/$(get_libdir)
		-DCOMP_COREBINARIES=ON
		-DUSE_SYSTEM_NIFTI=OFF
		-DUSE_SYSTEM_GIFTI=OFF
		-DUSE_SYSTEM_XMHTML=OFF
		-DUSE_SYSTEM_GTS=ON
		-DFETCHCONTENT_SOURCE_DIR_NIFTI_CLIB="${WORKDIR}/nifti_clib-${NIFTI_HASH}"
		-DFETCHCONTENT_SOURCE_DIR_GIFTI_CLIB="${WORKDIR}/gifti_clib-${GIFTI_HASH}"
		-DCOMP_GUI=ON
		-DCOMP_PLUGINS=ON
		-DUSE_OMP=ON
		-DCOMP_PYTHON=OFF
		-DUSE_SYSTEM_F2C=ON
	)
	tc-export CC
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	pushd src/python_scripts
		distutils-r1_src_compile
	popd
}

src_install() {
	cmake_src_install
	pushd src/python_scripts
		distutils-r1_src_install
	popd
	cd "${D}"
	rm usr/bin/mpeg_encode
}
