# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 multilib pax-utils toolchain-funcs

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
	sys-devel/llvm
	virtual/jpeg
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
                        epatch "${S}/${PATCH_DIR}/${PATCH_FILE}"
                fi
        done <"${S}/${PATCH_DIR}/series"
}

