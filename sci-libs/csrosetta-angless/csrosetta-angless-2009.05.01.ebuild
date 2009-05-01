# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SRC_BASE="http://spin.niddk.nih.gov/bax/software/CSROSETTA/"

DESCRIPTION="Chemical-Shift-ROSETTA -- ANGLESS DB"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/CSROSETTA/index.html"
SRC_URI="${SRC_BASE}/ANGLESS.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/csrosetta/
	ebegin "Installing files ..."
	doins -r ANGLESS || die
	eend
}

