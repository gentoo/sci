# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Plots data on map projections (with continental and political boundaries)"
HOMEPAGE="http://matplotlib.sourceforge.net/matplotlib.toolkits.basemap.basemap.html"
SRC_URI="mirror://sourceforge/matplotlib/${P}.tar.gz"

IUSE="examples"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT GPL-2"

DEPEND="sci-libs/shapelib
	sci-libs/proj"

RDEPEND="${DEPEND}
	>=dev-python/matplotlib-0.87.3
	dev-python/basemap-data"

src_unpack() {
	unpack ${A}
	# patch to use proj and shapelib system libraries
	epatch "${FILESDIR}/${PN}-syslib.patch"
	cd "${S}"
	mv src/pyproj.* .
	rm -rf src
}

src_install() {
	distutils_src_install
	dodoc Changelog README FAQ
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
