# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="SCAIN"

inherit perl-module

DESCRIPTION="Relational Database to Hierarchical (Stag/XML) Mapping"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-perl/DBIx-DBSchema-0.39
	dev-perl/libxml-perl
	>=dev-perl/Data-Stag-0.11
	dev-perl/DBI
	dev-perl/Parse-RecDescent
	dev-lang/perl"

RDEPEND="${DEPEND}"
