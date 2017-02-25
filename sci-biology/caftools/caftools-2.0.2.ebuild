# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Manipulate CAF files and convert to GAP4 format (not GAP5), ACE, PHRAP"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/caf
	http://www.ncbi.nlm.nih.gov/pmc/articles/PMC310697"
SRC_URI="
	ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/${P}.tar.gz
	ftp://ftp.sanger.ac.uk/pub/PRODUCTION_SOFTWARE/src/${PN}-2.0.tar.gz"

LICENSE="GRL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sci-libs/io_lib
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}"/Makefile.in-"${PV}".patch
	mv "${WORKDIR}"/caftools-2.0/man/*.{1,5} "${S}"/man/ || die
}

src_configure(){
	default
	sed \
		-e 's:prefix = /usr:prefix = $(DESTDIR)/usr:' \
		-i Makefile src/Makefile || die
}

# TODO: the 2.0.2 archive lacks manpages compared to 2.0, FIXME
# The man/Makefile.in is screwed in 2.0.2 so we cannot use it to install the manpage files,
# not even copying over whole caftools-2.0/man/ to caftools-2.0.2/man does not help.
src_install(){
	default
	doman man/*.[1-5] || die
	elog "Some usage info is at http://sarton.imb-jena.de/software/consed2gap/"
	elog "for some reason caf_find_misassemblies is gone from 2.0.2 version"
}
