# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Secondary structure propensities"
HOMEPAGE="http://abragam.med.utoronto.ca/software.html"
SRC_URI="http://pound.med.utoronto.ca/${PN}-Nov09.tar.gz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

S="${WORKDIR}"/${PN}

src_prepare() {
	sed \
		-e "s:\(REF\/\):${EPREFIX}/usr/share/${PN}/\1:g" \
		-i ${PN} || die
}

src_install() {
	dobin reref ${PN}
	dodoc README
	insinto /usr/share/${PN}
	doins -r eg* REF
}
