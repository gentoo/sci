# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy."
HOMEPAGE="http://code.google.com/p/numexpr/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=dev-python/setuptools-0.6_rc3
	>=dev-util/scons-1.2.0-r1"
RDEPEND="virtual/python
	>=dev-lang/python-2.3
	>=dev-python/numpy-1.3.1"
