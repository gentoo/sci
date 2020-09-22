# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=0.04
DIST_AUTHOR=SJCARBON

inherit perl-module

DESCRIPTION="Gene Ontology Database perl API"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/DBIx-DBStag-0.06
	dev-perl/FreezeThaw
	dev-perl/go-perl
	dev-perl/XML-LibXSLT
"

SRC_TEST=do
