# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils multilib pax-utils git-r3 toolchain-funcs

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurodebian/afni"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/motif[-static-libs]
	sci-libs/gsl
	dev-libs/expat
	x11-libs/libXpm
	media-libs/netpbm
	x11-libs/libGLw
	media-libs/qhull
	sys-devel/llvm
	media-video/mpeg-tools
	media-libs/libjpeg-turbo
	x11-libs/libXft
	x11-libs/libXi"

# x11-libs/motif[static-libs] breaks the build.
# See upstream discussion
# http://afni.nimh.nih.gov/afni/community/board/read.php?1,85348,85348#msg-85348

DEPEND="${RDEPEND}
	app-shells/tcsh"

S=${WORKDIR}/${P}


src_prepare() {
	PATCH_SOURCE="${S}/debian/patches/cmake_*" \
        EPATCH_FORCE="yes" epatch
}
