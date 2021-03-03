# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Perl part of the estscan package"
HOMEPAGE="https://sourceforge.net/projects/estscan/"
SRC_URI="http://downloads.sourceforge.net/estscan/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SRC_TEST="do"
