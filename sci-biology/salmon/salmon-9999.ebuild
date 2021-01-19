# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
EGIT_REPO_URI="https://github.com/COMBINE-lab/salmon.git"

LICENSE="GPL-3"
SLOT="0"

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
	dev-libs/cereal
"

BDEPEND="
	app-arch/unzip
	net-misc/curl
"
