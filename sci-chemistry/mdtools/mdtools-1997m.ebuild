# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

MY_P="MDToolsMarch97"

DESCRIPTION="Classes for the analysis and modification of protein structure and dynamics data."
HOMEPAGE="http://www.ks.uiuc.edu/~jim/mdtools/"
SRC_URI="${HOMEPAGE}${MY_P}.tar.gz"

LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="dev-python/numeric"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto $(python_get_sitedir)/${PN}
	doins *.py || die "no modules"
	insinto /usr/share/§{PN}
	doins -r data || die "no data"
}
