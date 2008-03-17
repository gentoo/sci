# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MYPV=${PV//./}
DOCPV=102

DESCRIPTION="Java-like matrix C++ templates"
HOMEPAGE="http://math.nist.gov/tnt/"
SRC_URI="http://math.nist.gov/tnt/${PN}${MYPV}.zip
	doc? ( http://math.nist.gov/tnt/${PN}${DOCPV}doc.zip )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND="sci-libs/tnt"

S="${WORKDIR}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	insinto /usr/include
	doins *.h || die
	use doc && dohtml doxygen/html/*
}
