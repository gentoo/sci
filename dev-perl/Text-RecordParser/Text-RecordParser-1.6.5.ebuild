# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="KCLARK"
inherit perl-module

DESCRIPTION="Perl module to read record-oriented files"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/Module-Install"
DEPEND="${RDEPEND}"

SRC_TEST="do"
