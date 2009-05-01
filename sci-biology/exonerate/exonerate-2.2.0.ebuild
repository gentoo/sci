# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="exonerate is a generic tool for pairwise sequence comparison"
HOMEPAGE="http://www.ebi.ac.uk/~guy/exonerate/"
SRC_URI="http://www.ebi.ac.uk/~guy/exonerate/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="largefile utils"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"

#src_unpack() {
#pwd
#	unpack ${A}
#cd "${S}"
#pwd
#	epatch ${FILESDIR}/${P}-gcc.patch
#}

src_compile() {

	econf \
	$( use_enable largefile ) \
	$( use_enable utils utilities ) \
	--enable-glib2 \
	|| die "econf failed"

	emake -j1 || die "emake failed"
}

src_install() {

	emake DESTDIR="${D}" install || die "Install failed"
	doman doc/man/man1/*.1
	dodoc README
}
