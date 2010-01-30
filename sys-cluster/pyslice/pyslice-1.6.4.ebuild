# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Templating system for parametric modeling."
HOMEPAGE="http://pyslice.sourceforge.net/"

SRC_URI="mirror://sourceforge/pyslice/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/python
	>=dev-lang/python-2.4"
DEPEND="${RDEPEND}
	dev-python/setuptools"
