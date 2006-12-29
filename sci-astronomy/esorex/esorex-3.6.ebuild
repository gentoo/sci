# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ESO Recipe Execution Tool to exec cpl scripts"
HOMEPAGE="http://www.eso.org/observing/cpl/esorex"
SRC_URI="ftp://ftp.hq.eso.org/pub/cpl/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sci-astronomy/cpl"

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	dodoc README AUTHORS NEWS TODO BUGS ChangeLog
	insinto /usr/share/doc/${PF}
	doins examples/*
}
