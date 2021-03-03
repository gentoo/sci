# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="KCLARK"

inherit perl-module

DESCRIPTION="Perl module to read record-oriented files"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Module-Install
	dev-perl/Readonly
	dev-perl/Test-Exception
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
