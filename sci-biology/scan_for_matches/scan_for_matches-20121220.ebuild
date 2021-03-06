# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pattern search through DNA sequences (aka patscan)"
HOMEPAGE="https://blog.theseed.org/servers/2010/07/scan-for-matches.html"
SRC_URI="https://www.theseed.org/servers/downloads/scan_for_matches.tgz -> ${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/scan_for_matches"

src_install(){
	dobin scan_for_matches
	dodoc README
}
