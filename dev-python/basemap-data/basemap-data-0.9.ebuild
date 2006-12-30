# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Data for basemap"
HOMEPAGE="http://matplotlib.sourceforge.net/matplotlib.toolkits.basemap.basemap.html"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

DEPEND="virtual/python"

src_install() {
	distutils_src_install
}
