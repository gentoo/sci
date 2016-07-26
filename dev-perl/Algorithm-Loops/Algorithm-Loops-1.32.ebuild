# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="TYEMQ"
DIST_A_EXT="zip"
DIST_VERSION="1.031"

inherit perl-module

DESCRIPTION="Looping constructs: NestedLoops, MapCar*, Filter, and NextPermute*"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}"
