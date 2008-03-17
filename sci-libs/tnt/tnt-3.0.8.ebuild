# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MYPV=${PV//./_}

DESCRIPTION="Template Numerical Toolkit: C++ headers for array and matrices"
HOMEPAGE="http://math.nist.gov/tnt/"
SRC_URI="http://math.nist.gov/tnt/${PN}_${MYPV}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	insinto /usr/include
	doins *.h || die
}
