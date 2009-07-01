# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Tidal Analysis in Python breaks hourly water level into tidal
components."
HOMEPAGE="http://tappy.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=">=sci-libs/scipy-0.3.2"
RDEPEND="${DEPEND}"

