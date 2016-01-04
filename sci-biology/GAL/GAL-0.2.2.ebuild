# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils perl-module

DESCRIPTION="Genome Annotation Library (incl. fasta_tool)"
HOMEPAGE="http://www.sequenceontology.org/software/GAL.html"
SRC_URI="http://www.sequenceontology.org/software/GAL_Code/${PN}_${PV}.tar.gz"

LICENSE="( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/perl-5.6.1
	dev-perl/Module-Build
	dev-perl/DBIx-Class
	dev-perl/IO-All
	dev-perl/Number-Format
	dev-perl/Set-IntSpan
	dev-perl/Statistics-Descriptive-Discrete
	dev-perl/Template-Toolkit
	dev-perl/Text-Graph
	dev-perl/Text-RecordParser
	dev-perl/Text-Table
	dev-perl/Exception-Class
	dev-perl/Test-Warn
	dev-perl/DBIx-Class
	dev-perl/URI"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}_${PV}"

src_prepare(){
	epatch "${FILESDIR}"/Build.PL.patch
}
