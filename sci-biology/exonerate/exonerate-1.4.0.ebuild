# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="exonerate is a generic tool for pairwise sequence comparison"
HOMEPAGE="http://www.ebi.ac.uk/~guy/exonerate/"
SRC_URI="http://www.ebi.ac.uk/~guy/exonerate/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="largefile utils"

DEPEND="dev-libs/glib"
RDEPEND=""

src_compile() {

	local myconf=""

	if has_version ">=dev-libs/glib-2.0"; then
		myconf="${myconf} --enable-glib2"
	fi

	econf \
	$( use_enable largefile ) \
	$( use_enable utils utilities ) \
	${myconf} \
	|| die "econf failed"

	emake -j1 || die "emake failed"
}

src_install() {

	emake DESTDIR="${D}" install || die "Install failed"
	doman doc/man/man1/*.1
	dodoc README
}
