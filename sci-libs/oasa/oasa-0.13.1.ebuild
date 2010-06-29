# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python library for manipulation of chemical structures"
HOMEPAGE="http://bkchem.zirael.org/oasa_en.html"
SRC_URI="http://bkchem.zirael.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo"

DEPEND=""
RDEPEND="cairo? ( >=dev-python/pycairo-1.2 )"
