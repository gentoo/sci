# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="Toolkit to find and trim adaptors, plot read lengths, qualities, map reads and submit to GenBank"
HOMEPAGE="http://code.google.com/p/biopieces"
SRC_URI=""
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="http://biopieces.googlecode.com/svn/trunk"
	KEYWORDS=""
else
	SRC_URI="http://biopieces.googlecode.com/files/biopieces_installer-"${PV}".sh"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

#    Ruby terminal-table ?

DEPEND=">=dev-lang/perl-5.8
	dev-perl/Bit-Vector
	dev-perl/SVG
	dev-perl/TermReadKey
	virtual/perl-Time-HiRes
	dev-perl/DBI
	dev-perl/XML-Parser
	dev-perl/Carp-Clan
	dev-perl/Class-Inspector
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/SOAP-Lite
	dev-perl/URI
	dev-perl/Inline
	dev-perl/Parse-RecDescent
	virtual/perl-version
	virtual/perl-DB_File
	dev-perl/DBD-mysql
	>=dev-lang/python-2.6
	dev-lang/ruby
	dev-ruby/gnuplot
	dev-ruby/narray
	dev-ruby/RubyInline"

# sci-biology/vmatch # http://www.vmatch.de/ # fecth restrict
# sci-biology/usearch-bin # http://www.drive5.com/usearch/ # fecth restrict

RDEPEND="${DEPEND}
	sci-biology/ncbi-tools
	sci-biology/muscle
	sci-biology/mummer
	sci-biology/blat
	sci-biology/bowtie
	sci-biology/bwa
	sci-biology/velvet
	sci-biology/idba
	sci-biology/Ray
	sci-biology/scan_for_matches"
