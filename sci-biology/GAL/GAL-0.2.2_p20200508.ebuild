# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

COMMIT="94af39622aab5ba48eb693f2327f6e90f1d202ed"

DESCRIPTION="Genome Annotation Library (incl. fasta_tool)"
HOMEPAGE="https://github.com/The-Sequence-Ontology/GAL"
SRC_URI="https://github.com/The-Sequence-Ontology/GAL/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

DEPEND="
	dev-perl/Config-Std
	virtual/perl-Data-Dumper
	dev-perl/Data-Types
	dev-perl/DBD-SQLite
	dev-perl/DBIx-Class
	dev-perl/IO-All
	dev-perl/Number-Format
	virtual/perl-Scalar-List-Utils
	dev-perl/Set-IntSpan-Fast
	dev-perl/Statistics-Descriptive
	dev-perl/Statistics-Descriptive-Discrete
	dev-perl/Template-Toolkit
	dev-perl/Text-Graph
	dev-perl/Text-RecordParser
	dev-perl/Text-Table
	dev-perl/Exception-Class
	dev-perl/Test-Warn
	dev-perl/URI
	sci-biology/fasta
"
RDEPEND="${DEPEND}"
BDEPEND="dev-perl/Module-Build"

PATCHES=(
	"${FILESDIR}/Build.PL.patch"
)
