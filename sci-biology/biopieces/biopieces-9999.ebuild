# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

USE_RUBY="ruby22 ruby23 ruby24"

if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="http://biopieces.googlecode.com/svn/trunk"
	KEYWORDS=""
	inherit subversion
else
	SRC_URI="http://biopieces.googlecode.com/files/biopieces_installer-${PV}.sh"
	KEYWORDS=""
fi

inherit ruby-fakegem python-single-r1

DESCRIPTION="Trim adaptors, plot read lengths, qualities, map reads and submit to GenBank"
HOMEPAGE="http://code.google.com/p/biopieces"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

#    Ruby terminal-table ?

CDEPEND="${PYTHON_DEPS}
	>=dev-lang/perl-5.8
	dev-perl/libwww-perl
	dev-perl/Bit-Vector
	dev-perl/Carp-Clan
	dev-perl/Class-Inspector
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/HTML-Parser
	dev-perl/Inline
	dev-perl/Parse-RecDescent
	dev-perl/SOAP-Lite
	dev-perl/SVG
	dev-perl/TermReadKey
	dev-perl/URI
	dev-perl/XML-Parser
	virtual/perl-version
	virtual/perl-DB_File
	virtual/perl-Time-HiRes"

DEPEND="${CDEPEND}"

ruby_add_bdepend "dev-ruby/RubyInline"
ruby_add_rdepend "dev-ruby/gnuplot dev-ruby/narray"

# sci-biology/vmatch # http://www.vmatch.de/ # fecth restrict
# sci-biology/usearch-bin # http://www.drive5.com/usearch/ # fecth restrict

RDEPEND="${CDEPEND}
	sci-biology/ncbi-tools
	sci-biology/muscle
	sci-biology/mummer
	sci-biology/blat
	sci-biology/bowtie
	sci-biology/bwa
	sci-biology/velvet
	sci-biology/Ray
	sci-biology/scan_for_matches
	sci-biology/idba"
