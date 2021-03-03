# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="ANDYA"

inherit perl-module

DESCRIPTION="Fast handling of sets containing integer spans"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Data-Types
	dev-perl/Module-Build"

SRC_TEST="do"
