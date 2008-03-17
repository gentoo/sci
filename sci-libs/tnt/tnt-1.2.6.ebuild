# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MYPV=${PV//./}
DOCPV=120

DESCRIPTION="Template Numerical Toolkit: C++ headers for array and matrices"
HOMEPAGE="http://math.nist.gov/tnt/"
SRC_URI="http://math.nist.gov/tnt/${PN}_${MYPV}.zip
	doc? ( http://math.nist.gov/tnt/${PN}_${DOCPV}doc.zip )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	insinto /usr/include
	doins *.h || die
	use doc && dohtml html/*
}
