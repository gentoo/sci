# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Secondary structure propensities"
HOMEPAGE="http://abragam.med.utoronto.ca/software.html"
SRC_URI="http://pound.med.utoronto.ca/${PN}-Nov09.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

S="${WORKDIR}"/${PN}

src_install() {
	dobin reref ${PN}
	dodoc README
	insinto /usr/share/${PN}
	doins -r eg* REF
}
