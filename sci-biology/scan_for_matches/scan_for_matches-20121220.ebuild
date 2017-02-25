# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

S="${WORKDIR}"/scan_for_matches

DESCRIPTION="Pattern search through DNA sequences (aka patscan)"
HOMEPAGE="http://blog.theseed.org/servers/2010/07/scan-for-matches.html"
SRC_URI="http://www.theseed.org/servers/downloads/scan_for_matches.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	dobin scan_for_matches
	dodoc README
}
