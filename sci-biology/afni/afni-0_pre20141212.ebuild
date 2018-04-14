# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurodebian/afni"
EGIT_COMMIT="debian/0.20141224_dfsg.1-1"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/expat
	media-libs/netpbm
	media-libs/qhull
	media-video/mpeg-tools
	sci-libs/gsl
	sys-devel/llvm:*
	virtual/jpeg:0
	x11-libs/libGLw
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXpm
	x11-libs/motif[-static-libs]"

# x11-libs/motif[static-libs] breaks the build.
# See upstream discussion
# http://afni.nimh.nih.gov/afni/community/board/read.php?1,85348,85348#msg-85348

DEPEND="${RDEPEND}
	app-shells/tcsh"

PATCH_DIR="debian/patches"

src_prepare() {
	while read PATCH_FILE; do
		if  [[ $PATCH_FILE == cmake* ]] ; then
			epatch -p1 "${S}/${PATCH_DIR}/${PATCH_FILE}"
		fi
	done <"${S}/${PATCH_DIR}/series"
}

src_configure() {
	local mycmakeargs=(
		-DAFNI_SHOWOFF:STRING="=Debian-$(DEB_BUILD_GNU_TYPE)"
		-DBUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DCMAKE_SKIP_RPATH:BOOL=OFF
		-DCMAKE_INSTALL_RPATH:STRING="/usr/lib/afni/lib"
		-DCMAKE_EXE_LINKER_FLAGS:STRING="$(LDFLAGS) -Wl,--no-undefined"
		-DCMAKE_MODULE_LINKER_FLAGS:STRING="$(LDFLAGS)"
		-DCMAKE_SHARED_LINKER_FLAGS:STRING="$(LDFLAGS) -Wl,--no-undefined"
		-DAFNI_BUILD_LOCAL_NIFTICLIBS:BOOL=OFF
		-DAFNI_BUILD_LOCAL_GIFTI:BOOL=OFF
		-DAFNI_BUILD_LOCAL_NIFTI:BOOL=OFF
		-DAFNI_BUILD_LOCAL_3DEDGE3:BOOL=ON
		-DAFNI_BUILD_WITH_LESSTIF2:BOOL=OFF
		-DAFNI_BUILD_TESTS:BOOL=ON
		-DAFNI_INSTALL_BIN_DIR:STRING=/lib/afni/bin
		-DAFNI_INSTALL_LIB_DIR:STRING=/lib/afni/lib
		-DAFNI_INSTALL_INCLUDE_DIR:STRING=/include/afni
		-DAFNI_INSTALL_PLUGIN_DIR:STRING=/lib/afni/plugins
		-DAFNI_INSTALL_SCRIPT_DIR:STRING=/share/afni/scripts
		-DAFNI_INSTALL_PICS_DIR:STRING=/share/afni/pics
		-DAFNI_INSTALL_POEMS_DIR:STRING=/share/afni/poems
		-DAFNI_INSTALL_HTML_DIR:STRING=/share/afni/html
		-DAFNI_INSTALL_ATLAS_DIR:STRING=/share/afni/atlases
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DAFNI_BUILD_CORELIBS_ONLY:BOOL=OFF
		)
	cmake-utils_src_configure
}
