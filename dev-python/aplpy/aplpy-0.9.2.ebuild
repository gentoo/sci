# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit distutils

MYPN=APLpy
MYP="${MYPN}-${PV}"

DESCRIPTION="Astronomical Plotting Library in Python"
HOMEPAGE="http://aplpy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

DEPEND=">=dev-python/numpy-1.3
	>=dev-python/matplotlib-0.98.5.2
	>=dev-python/pyfits-2.1
	>=dev-python/pywcs-1.4
	>=sci-libs/scipy-0.7"

RDEPEND="${DEPEND}"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"

S="${WORKDIR}/${MYPN}"

