# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PV=${PV/_beta/-beta}

DESCRIPTION="Navigation scripting & testing utility for PhantomJS and SlimerJS"
HOMEPAGE="http://casperjs.org/"
SRC_URI="https://github.com/n1k0/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="<www-client/phantomjs-2.0.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	return
}

src_install() {
	insinto /usr/share/${P}/
	doins -r modules/
	doins -r tests/
	doins package.json

	insinto /usr/share/${P}/bin
	doins bin/bootstrap.js
	doins bin/usage.txt

	exeinto /usr/share/${P}/bin
	doexe bin/casperjs
	dosym ../share/${P}/bin/casperjs /usr/bin/casperjs

	dodoc CHANGELOG.md CONTRIBUTORS.md README.md
}
