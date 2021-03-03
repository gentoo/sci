# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="TYEMQ"
DIST_A_EXT="tar.gz"
DIST_VERSION="1.032"

inherit perl-module

DESCRIPTION="Looping constructs: NestedLoops, MapCar*, Filter, and NextPermute*"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}"
