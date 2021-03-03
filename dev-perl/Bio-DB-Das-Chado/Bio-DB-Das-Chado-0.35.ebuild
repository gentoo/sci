# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="SCAIN"

inherit perl-module

DESCRIPTION="A Chado database interface for Gbrowse-2"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/DBI
	dev-perl/DBD-Pg
	dev-perl/Module-Build"

SRC_TEST="do"
