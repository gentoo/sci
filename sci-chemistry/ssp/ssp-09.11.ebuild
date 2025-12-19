# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Secondary structure propensities"
HOMEPAGE="http://abragam.med.utoronto.ca/software.html"
SRC_URI="http://pound.med.utoronto.ca/${PN}-Nov09.tar.gz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
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
