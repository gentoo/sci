# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_MODNAME="CGNS"

inherit distutils

MY_PN="CGNS"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python language bindings for the CGNS library"
HOMEPAGE="http://pypi.python.org/pypi/CGNS/"
SRC_URI="mirror://pypi/C/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sci-libs/cgnslib"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}/${MY_P}"
