# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="An accumulation place for pure-scheme Guile modules"
HOMEPAGE="http://www.nongnu.org/guile-lib/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-scheme/guile[regex,deprecated]"
DEPEND="${RDEPEND} !<dev-libs/g-wrap-1.9.8"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
