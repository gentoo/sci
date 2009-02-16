# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils ruby

DESCRIPTION="LaTeX equation editor"
HOMEPAGE="http://rlehy.free.fr/"
SRC_URI="http://rlehy.free.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-ruby/qt4-qtruby
	virtual/latex-base
	app-text/dvipng
	media-gfx/pstoedit
	media-gfx/imagemagick
	x11-misc/xdg-utils"

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install-bin || die "emake install failed"
	# install-doc is simple and not what we want
	pod2man doc/ekee.pod ekee.1
	doman ekee.1
	dodoc changelog AUTHORS README TODO copyright
	make_deskop_entry ekee Ekee
}

pkg_postinst() {
	elog "${CATEGORY}/${PN} is in development / testing phase."
	elog "Report bugs or improvements at:"
	elog "http://bugs.gentoo.org/"
}
