# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
SRC_URI="https://github.com/COMBINE-lab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-libs/boost:=[threads]
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	app-arch/bzip2
	app-arch/xz-utils
	>=dev-libs/jemalloc-5.0.1
	>=dev-cpp/tbb-2018.20180312
	sci-biology/pufferfish
	sci-libs/staden-io
	sci-libs/libgff
	dev-libs/cereal
"

BDEPEND="
	app-arch/unzip
	net-misc/curl
"

PATCHES=(
	"${FILESDIR}/${P}-do-not-fetch-pufferfish.patch"
	"${FILESDIR}/${P}-allow-newer-boost.patch"
)
