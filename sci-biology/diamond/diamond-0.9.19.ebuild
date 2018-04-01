# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs cmake-utils

DESCRIPTION="Alternative of blastp/blastx searches using DNA short reads through protein db"
HOMEPAGE="http://ab.inf.uni-tuebingen.de/software/diamond
	https://github.com/bbuchfink/diamond"
SRC_URI="https://github.com/bbuchfink/diamond/archive/v${PV}.tar.gz"
# EGIT_REPO_URI="https://github.com/bbuchfink/diamond.git"

LICENSE="AGPL-3" # diamond_manual.pdf says AGPL but src/COPYING used to say BSD?
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# uses SSE instructions, SSSE3 and POPCNT

DEPEND=""
RDEPEND="${DEPEND}"

# use cmake -DBUILD_STATIC=ON to create a statically linked binary
src_install(){
	cmake-utils_src_install
	dodoc README.rst diamond_manual.pdf
}
