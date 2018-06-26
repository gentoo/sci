# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
SRC_URI="https://github.com/COMBINE-lab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/COMBINE-lab/RapMap/archive/salmon-v0.10.2.zip -> ${P}_RapMap.zip
	https://github.com/USCiLab/cereal/archive/v1.2.2.tar.gz -> cereal-1.2.2.tar.gz
	https://github.com/COMBINE-lab/bwa/archive/v0.7.12.5.tar.gz -> bwa-0.7.12.5.tar.gz
	https://github.com/COMBINE-lab/libgff/archive/v1.1.tar.gz -> libgff-1.1.tgz
	https://github.com/COMBINE-lab/staden-io_lib/archive/v1.14.8.1.tar.gz -> staden-io_lib-1.14.8.tar.gz
	https://github.com/COMBINE-lab/spdlog/archive/v0.16.1.tar.gz -> spdlog-0.16.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-no-boost-static.patch
		"${FILESDIR}"/salmon-0.10.2_remove_curl_call.patch
		"${FILESDIR}"/salmon-0.10.2_remove_curl_calls.patch
		"${FILESDIR}"/salmon-0.10.2_fix_lib_dir.patch
		"${FILESDIR}"/salmon-0.10.2_fix_tests.patch
		"${FILESDIR}"/salmon-0.10.2_TestSalmonQuasi.cmake.patch )

RDEPEND="${DEPEND}"
# budled copies of:
# sci-biology/bwa-0.7.12.5
# sci-biology/jellyfish
# sci-biology/staden-1.14.8.1
# sci-biology/gfftools
#
# libgff-1.1 from https://github.com/Kingsford-Group/libgff
#    actually unreleased version from https://github.com/COMBINE-lab/libgff/archive/v1.1.tar.gz
#    https://github.com/Kingsford-Group/libgff/issues/1
#
# dev-libs/spdlog-0.16.1
# cereal-1.2.2

# see the many curl executions:
# salmon-0.10.2$ find . -type f | xargs grep curl 2>/dev/null
#
DEPEND="net-misc/curl
		app-arch/unzip
		sys-libs/zlib
		app-arch/bzip2
		app-arch/xz-utils
		dev-libs/boost:0[threads]
		>=dev-libs/jemalloc-5.0.1
		>=dev-cpp/tbb-2018.20180312"
RDEPEND="${DEPEND}"
