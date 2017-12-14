# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Perl library of modules to manipulate SwissProt flatfiles"
HOMEPAGE="http://swissknife.sourceforge.net/"
SRC_URI="ftp://ftp.ebi.ac.uk/pub/software/swissprot/Swissknife/Swissknife_${PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Module-Build"
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.002:="
	#dev-perl/Carp
	#dev-perl/Data-Dumper
	#dev-perl/Exporter"

SRC_TEST=no

S="${WORKDIR}"/Swissknife_${PV}
