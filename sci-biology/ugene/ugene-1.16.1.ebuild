# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="A free open-source cross-platform bioinformatics software"
HOMEPAGE="http://ugene.unipro.ru"
SRC_URI="http://${PN}.unipro.ru/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse2"

DEPEND="
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

LANGS="cs en ru zh"

src_configure() {
	local CONFIG_OPTS
	if use amd64; then
		CONFIG_OPTS+=( CONFIG+="x64" )
	elif use ppc; then
		CONFIG_OPTS+=( CONFIG+="ppc" )
	fi

	use cpu_flags_x86_sse2 && CONFIG_OPTS+=( use_sse2 )

	eqmake4 $CONFIG_OPTS || die
}
