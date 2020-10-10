# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="BRICKER"
inherit perl-module

DESCRIPTION="Load and save configuration files in a standard format"

#LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Class-Std
	dev-perl/Module-Build
"
DEPEND="${RDEPEND}"
