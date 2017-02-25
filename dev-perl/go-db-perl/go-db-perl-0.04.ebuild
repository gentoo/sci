# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SJCARBON

inherit perl-module

DESCRIPTION="Gene Ontology Database perl API"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-perl/FreezeThaw
	dev-perl/XML-LibXSLT
	>=dev-perl/DBIx-DBStag-0.06
	dev-perl/go-perl"

SRC_TEST=do
