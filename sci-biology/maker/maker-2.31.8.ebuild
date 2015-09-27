# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-module

DESCRIPTION="A genome annotation viewer and pipeline for small eukaryota and prokaryota"
HOMEPAGE="http://www.yandell-lab.org/software/maker.html"
SRC_URI="maker-"${PV}".tgz"

RESTRICT="fetch"

# for academia: GPL-v2 or Artistic-2
# for commercial: ask
LICENSE="|| ( GPL-2 Artistic-2 )"
SLOT="0"
KEYWORDS=""
IUSE=""

# http://search.cpan.org/~rgarcia/Perl-Unsafe-Signals-0.02/
# http://search.cpan.org/~rybskej/forks-0.36/lib/forks.pm
# http://search.cpan.org/~rybskej/forks-0.36/lib/forks/shared.pm
# http://search.cpan.org/~dconway/IO-Prompt-0.997002/lib/IO/Prompt.pm
DEPEND="virtual/mpi
	dev-perl/DBI
	dev-perl/DBD-SQLite
	dev-perl/File-Which
	dev-perl/Bit-Vector
	dev-perl/Inline-C
	dev-perl/IO-All
	dev-perl/libwww-perl
	dev-perl/DBD-Pg
	virtual/perl-Module-Build
	>=sci-biology/bioperl-1.6
	sci-biology/ncbi-tools || ( sci-biology/ncbi-tools++ )
	sci-biology/snap
	sci-biology/repeatmasker
	sci-biology/exonerate
	sci-biology/augustus"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/maker/src

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "maker-"${PV}".tgz and place it into ${DISTDIR}"
}

src_compile(){
	perl Build.PL || die
	./Build install || die
}
