# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion

MYPN=BuildTools

DESCRIPTION="COIN-OR build tools for out of portage builds"
HOMEPAGE="https://projects.coin-or.org/BuildTools/"
ESVN_REPO_URI="https://projects.coin-or.org/svn/BuildTools/releases/${PV}"
SRC_URI=""

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

src_install() {
	dobin run_autotools
	insinto /usr/include
	doins headers/*
	insinto /usr/share/coin
	doins share/config.site
	insinto /usr/share/coin/libtool
	doins coin.m4
	dosym ../../libtool/aclocal/libtool.m4 /usr/share/coin/libtool/libtool.m4
	insinto /usr/share/coin/BuildTools
	doins install-sh ltmain.sh missing Makemain.inc
	dosym ../BuildTools/ltmain.sh /usr/share/coin/libtool/ltmain.sh
}
