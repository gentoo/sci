# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="Pivy-${PV}"

DESCRIPTION="a Coin binding for Python"
HOMEPAGE="http://pivy.coin3d.org/"
SRC_URI="http://omploader.org/vMnl2dA/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	media-libs/coin
	>=media-libs/SoQt-1.4.2_alpha"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"
