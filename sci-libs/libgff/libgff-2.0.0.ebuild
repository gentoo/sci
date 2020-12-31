# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="GFF/GTF parsing code library"
HOMEPAGE="https://github.com/COMBINE-lab/libgff"
SRC_URI="https://github.com/COMBINE-lab/libgff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
