# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

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
