# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Perl library of modules to manipulate SwissProt flatfiles"
HOMEPAGE="http://swissknife.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

DEPEND="dev-perl/Module-Build"
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.002:="
	#dev-perl/Carp
	#dev-perl/Data-Dumper
	#dev-perl/Exporter"

S="${WORKDIR}"/swissknife_${PV}
