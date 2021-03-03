# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="GWADEJ"
DIST_A_EXT="tar.gz"

inherit perl-module

DESCRIPTION="Perl module for generating simple text-based graphs"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-lang/perl
	dev-perl/Moo
"
RDEPEND="${DEPEND}"
