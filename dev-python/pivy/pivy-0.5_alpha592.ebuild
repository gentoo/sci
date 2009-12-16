# Copyright 1999-2009  Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="Pivy-${PV}"

DESCRIPTION="a Coin binding for Python"
HOMEPAGE="http://pivy.coin3d.org/"
SRC_URI="http://omploader.org/vMnl2dA/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/coin
	=sci-libs/soqt-1.4.2_alpha4181"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

