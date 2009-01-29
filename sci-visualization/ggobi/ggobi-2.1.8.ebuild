# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils

DESCRIPTION="Visualization program for exploring high-dimensional data"
HOMEPAGE="http://www.ggobi.org"
SRC_URI="http://www.ggobi.org/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND=">=media-gfx/graphviz-2.6
	>=x11-libs/gtk+-2.6
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf $(use_with !minimal all-plugins)
}

src_compile() {
	emake || die "emake failed"
	# generate default configuration
	emake ggobirc || die "ggobi configuration generation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto /etc/xdg/ggobi
	doins ggobirc || die
}
