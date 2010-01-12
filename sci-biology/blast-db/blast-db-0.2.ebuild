# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit check-reqs

DESCRIPTION="blast db"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/staff/tao/URLAPI/blastdb.html"
SRC_URI="http://www.ncbi.nlm.nih.gov/blast/docs/update_blastdb.pl"

LICENSE="public-domain"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long
	virtual/perl-libnet
	virtual/perl-PodParser"

RESTRICT="binchecks strip"

src_unpack() {
	cp "${DISTDIR}"/${A} "${WORKDIR}"
}

src_install() {
	dobin update_blastdb.pl || exit
}
