# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="CAF is a text format for describing sequence assemblies"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/caf/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/caftools-2.0.2.tar.gz
		ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/caftools-2.0.tar.gz"
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
	epatch "${FILESDIR}"/Makefile.in-"${PV}".patch || die
	mv "${WORKDIR}"/caftools-2.0/man/*.1 "${WORKDIR}"/caftools-2.0/man/*.5 "${S}"/man || die
}

src_configure(){
	econf || die
	sed -i 's:prefix = /usr:prefix = $(DESTDIR)/usr:' Makefile || die
	sed -i 's:prefix = /usr:prefix = $(DESTDIR)/usr:' src/Makefile || die
}

# TODO: the 2.0.2 archive lacks manpages compared to 2.0, FIXME
# The man/Makefile.in is screwed in 2.0.2 so we cannot use it to install the manpage files,
# not even copying over whole caftools-2.0/man/ to caftools-2.0.2/man does not help.
src_install(){
	emake install DESTDIR="${D}" || die
	doman man/*.[1-5] || die
	einfo "Some usage info is at http://sarton.imb-jena.de/software/consed2gap/"
	einfo "for some reason caf_find_misassemblies is gone from 2.0.2 version"
}
