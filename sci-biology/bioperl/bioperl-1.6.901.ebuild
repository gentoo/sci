# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bioperl/bioperl-1.6.1.ebuild,v 1.3 2009/10/02 14:51:51 weaver Exp $

EAPI="2"

inherit perl-module

SUBPROJECTS="+db +network +run"
MIN_PV="1.6"

DESCRIPTION="Perl tools for bioinformatics - Core modules"
HOMEPAGE="http://www.bioperl.org/"
# SRC_URI="http://www.bioperl.org/DIST/BioPerl-${PV}.tar.bz2"
SRC_URI="http://www.cpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-${PV}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-minimal graphviz sqlite ${SUBPROJECTS}"

CDEPEND=">=perl-core/Module-Build-0.380.0
	dev-perl/Data-Stag
	dev-perl/libwww-perl
	!minimal? (
		dev-perl/Ace
		dev-perl/Spreadsheet-ParseExcel
		dev-perl/Spreadsheet-WriteExcel
		>=dev-perl/XML-SAX-0.15
		dev-perl/Graph
		dev-perl/SOAP-Lite
		dev-perl/Array-Compare
		dev-perl/SVG
		dev-perl/XML-Simple
		dev-perl/XML-Parser
		dev-perl/XML-Twig
		>=dev-perl/HTML-Parser-3.60
		>=dev-perl/XML-Writer-0.4
		dev-perl/Clone
		dev-perl/XML-DOM
		dev-perl/set-scalar
		dev-perl/XML-XPath
		dev-perl/XML-DOM-XPath
		dev-perl/Algorithm-Munkres
		dev-perl/Data-Stag
		dev-perl/Math-Random
		dev-perl/PostScript
		dev-perl/Convert-Binary-C
		dev-perl/SVG-Graph
		dev-perl/IO-String
		dev-perl/Class-Inspector
		dev-perl/Sort-Naturally
	)
	graphviz? ( dev-perl/GraphViz )
	sqlite? ( dev-perl/DBD-SQLite )"
DEPEND="virtual/perl-Module-Build
	${CDEPEND}"
# In perl-overlay
#	>=virtual/perl-ExtUtils-Manifest-1.52 (to CDEPEND?)
#	>=perl-CPAN/perl-CPAN-1.81
RDEPEND="${CDEPEND}"
PDEPEND="!minimal? ( dev-perl/Bio-ASN1-EntrezGene )
	db? ( >=sci-biology/bioperl-db-${MIN_PV} )
	network? ( >=sci-biology/bioperl-network-${MIN_PV} )
	run? ( >=sci-biology/bioperl-run-${MIN_PV} )"

S="${WORKDIR}/BioPerl-${PV}"

src_configure() {
	sed -i -e '/add_post_install_script.*symlink_script.pl/d' \
		-e "/'CPAN' *=> *1.81/d" \
		-e "/'ExtUtils::Manifest' *=> *'1.52'/d" "${S}/Build.PL" || die

	if use minimal && use graphviz; then die "USE flags minimal and graphviz cannot be used together"; fi
	perl-module_src_configure
}

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
}
