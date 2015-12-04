# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit git-r3

DESCRIPTION="A simle medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/MRIcron"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurolabusc/MRIcron.git"

LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="dev-lang/fpc
	dev-lang/lazarus"

src_compile() {
	lazbuild -B --lazarusdir="/usr/share/lazarus/" mricron.lpr || die
}

src_install() {
	dobin mricron
	dobin dcm2nii
	dobin dcm2niigui
	dobin pigz_mricron
}

