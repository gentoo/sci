# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="This module converts between a given COARDS time specification and
a Python datetime object"
HOMEPAGE="http://dealmeida.net/"

SRC_URI="http://cheeseshop.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND="virtual/python
	>=dev-lang/python-2.3"

