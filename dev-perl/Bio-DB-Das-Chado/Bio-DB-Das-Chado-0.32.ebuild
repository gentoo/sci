# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="SCAIN"
inherit perl-module

DESCRIPTION="A Chado database interface for Gbrowse-2"

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/DBD-Pg"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST="do"
