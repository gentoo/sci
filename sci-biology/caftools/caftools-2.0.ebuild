# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="CAF is a text format for describing sequence assemblies"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/caf/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/caftools-2.0.tar.gz"
# another source with only the old version is at
# ftp://ftp.sanger.ac.uk/pub4/resources/software/caf/caftools-2.0.tar.gz
# newer version will probably appear at ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/io_lib
		>=dev-lang/perl-5.002"
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}"/Makefile.in.patch || die
}

src_configure(){
	econf || die
	sed -i 's#prefix = /usr#prefix = $(DESTDIR)/usr#' Makefile || die
	sed -i 's#prefix = /usr#\#prefix = $(DESTDIR)/usr#' src/Makefile || die
}

src_install(){
	emake install DESTDIR="${D}" || die
	einfo "Some usage info is at http://sarton.imb-jena.de/software/consed2gap/"
}
