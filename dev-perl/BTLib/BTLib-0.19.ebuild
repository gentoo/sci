# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR=""
inherit perl-module
SRC_URI="http://downloads.sourceforge.net/estscan/BTLib-0.19.tar.gz"

DESCRIPTION=" A part of the estscan package"

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"
