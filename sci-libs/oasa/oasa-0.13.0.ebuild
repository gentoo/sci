# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A python library for manipulation of chemical structures"
HOMEPAGE="http://bkchem.zirael.org/oasa_en.html"
SRC_URI="http://bkchem.zirael.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo"

DEPEND=">=dev-lang/python-2.4"

RDEPEND="${DEPEND}
	cairo? ( >=dev-python/pycairo-1.2 )"
