# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR="LEONT"

inherit perl-module

DESCRIPTION="Facility for creating read-only scalars, arrays, and hashes"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Test-Exception
	dev-perl/Sub-Exporter"
