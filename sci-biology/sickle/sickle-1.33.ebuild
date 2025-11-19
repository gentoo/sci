# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Windowed adaptive quality-based trimming tool for FASTQ data"
HOMEPAGE="https://github.com/najoshi/sickle"
if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/najoshi/sickle"
else
	SRC_URI="https://github.com/najoshi/sickle/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="virtual/zlib:="
RDEPEND="${DEPEND}"

src_install(){
	dobin sickle
	dodoc README.md
}
