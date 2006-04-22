# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator autotools

MY_PV="$(delete_all_version_separators ${PV})"
S="${WORKDIR}/${PN}${MY_PV}"

DESCRIPTION="Anti-Grain Geometry - A High Quality Rendering Engine for C++"
HOMEPAGE="http://antigrain.com/"
SRC_URI="http://antigrain.com/${PN}${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="virtual/x11"
DEPEND="${RDEPEND}
	>=media-libs/freetype-2"

src_compile() {
	use examples || sed -i -e 's/examples//' Makefile.am
	eautoreconf || die "eautoreconf failed"
	econf || die "econf failed"
	emake || die "make failed!"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed!"
	dodoc readme README.txt authors ChangeLog news
	insinto /usr/share/doc/${P}
	doins -r tutorial
}

