# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/maq/maq-0.7.1.ebuild,v 1.3 2009/02/26 17:36:19 weaver Exp $

DESCRIPTION="SAM (Sequence Alignment/Map), a format for storing large nucleotide sequence alignments"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	sed -i 's/^CFLAGS=/CFLAGS+=/' "${S}"/{Makefile,misc/Makefile}
}

src_install() {
	dobin razip bgzip samtools || die
	dobin misc/{faidx,md5sum-lite,md5fa,maq2sam-short,maq2sam-long,wgsim,*.pl} || die
	insinto /usr/share/${PN}
	doins -r examples || die
	doman ${PN}.1 || die
	dodoc ChangeLog NEWS
}
