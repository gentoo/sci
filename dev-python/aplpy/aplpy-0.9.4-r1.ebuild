# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MYPN=APLpy
MYP="${MYPN}-${PV}"

DESCRIPTION="Astronomical Plotting Library in Python"
HOMEPAGE="http://aplpy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"

DEPEND=">=dev-python/numpy-1.3"
RDEPEND="${DEPEND}
	>=dev-python/matplotlib-0.99
	>=dev-python/pyfits-2.1
	>=dev-python/pywcs-1.5.1
	>=sci-libs/scipy-0.7"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MYP}"
