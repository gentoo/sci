# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Alternative of blastp/blastx searches using DNA short reads through protein db"
HOMEPAGE="http://ab.inf.uni-tuebingen.de/software/diamond
	https://github.com/bbuchfink/diamond"
SRC_URI="https://github.com/bbuchfink/diamond/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3" # diamond_manual.pdf says AGPL but src/COPYING used to say BSD?
SLOT="0"
KEYWORDS="~amd64 ~x86"

# uses SSE instructions, SSSE3 and POPCNT
# use cmake -DBUILD_STATIC=ON to create a statically linked binary
