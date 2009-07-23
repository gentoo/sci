# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Collection of python tools for astronomy"
HOMEPAGE="http://www.astro.rug.nl/software/kapteyn"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="sci-astronomy/wcslib
	dev-python/numpy"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die
	fi
}
