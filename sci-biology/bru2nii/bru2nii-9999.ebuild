# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit git-r3

DESCRIPTION="Converts Bruker ParaVision MRI data to the NIfTI file format"
HOMEPAGE="https://github.com/neurolabusc/Bru2Nii"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurolabusc/Bru2Nii.git"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
IUSE="gui"

RDEPEND=""
DEPEND="dev-lang/fpc
	gui? ( dev-lang/lazarus )"

src_compile() {
	fpc -Tlinux Bru2.lpr || die
	if use gui ; then
		lazbuild -B --lazarusdir="/usr/share/lazarus/" Bru2Nii.lpr || die
	fi
}

src_install() {
	dobin Bru2
	use gui && dobin Bru2Nii
	dodoc README.md
}

