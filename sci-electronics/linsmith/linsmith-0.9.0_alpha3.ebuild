# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="linSmith is a Smith Charting program, mainly designed for
educational use."
HOMEPAGE="http://jcoppens.com/soft/linsmith/index.en.php"

MY_P="linsmith-0.9.0a3"
SRC_URI="mirror://sourceforge/linsmith/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=gnome-base/libgnomeprint-2.10.3
		>=dev-libs/libxml2-2.6.20-r2
		>=gnome-base/libgnomeui-2.10.1"
RDEPEND=""

S=${WORKDIR}/${MY_P}


src_compile() {
	cd ${S}

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS NEWS README ChangeLog TODO
}
