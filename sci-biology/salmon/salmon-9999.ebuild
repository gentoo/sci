# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib cmake-utils git-r3

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
EGIT_REPO_URI="https://github.com/COMBINE-lab/salmon.git"
#SRC_URI="https://github.com/COMBINE-lab/RapMap/archive/salmon-v0.10.2.zip -> ${P}_RapMap.zip
#    https://github.com/USCiLab/cereal/archive/v1.2.2.tar.gz -> cereal-1.2.2.tar.gz
#    https://github.com/COMBINE-lab/bwa/archive/v0.7.12.5.tar.gz -> bwa-0.7.12.5.tar.gz
#    https://github.com/COMBINE-lab/libgff/archive/v1.1.tar.gz -> libgff-1.1.tgz
#    https://github.com/COMBINE-lab/staden-io_lib/archive/v1.14.8.1.tar.gz -> staden-io_lib-1.14.8.tar.gz
#    https://github.com/COMBINE-lab/spdlog/archive/v0.16.1.tar.gz -> spdlog-0.16.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

PATCHES=( "${FILESDIR}"/salmon-0.10.2-no-boost-static.patch
	"${FILESDIR}"/salmon-0.10.2_remove_curl_call.patch
	"${FILESDIR}"/salmon-0.10.2_remove_curl_calls.patch
	"${FILESDIR}"/salmon-0.10.2_fix_lib_dir.patch
	"${FILESDIR}"/salmon-0.10.2_fix_tests.patch
	"${FILESDIR}"/salmon-0.10.2_TestSalmonQuasi.cmake.patch )

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
DEPEND="net-misc/curl
		app-arch/unzip
		sys-libs/zlib
		app-arch/bzip2
		app-arch/xz-utils
		dev-libs/boost:0[threads]
		>=dev-libs/jemalloc-5.0.1
		>=dev-cpp/tbb-2018.20180312"
RDEPEND="${DEPEND}"

# https://github.com/COMBINE-lab/salmon/issues/19
#
# contains bundled copies of https://github.com/jemalloc/jemalloc
# https://github.com/gabime/spdlog
# https://github.com/efficient/libcuckoo
# https://github.com/greg7mdp/sparsepp
# https://github.com/COMBINE-lab/RapMap , actually runs curl to fetch it
# https://github.com/Kingsford-Group/libgff
# sci-libs/io_lib
#
# https://github.com/COMBINE-lab/salmon/issues/19#issuecomment-144721158
# modified bwa copy
#
# and maybe more

# See https://github.com/COMBINE-lab/salmon/issues/236 for Cmake tweaks needed by Debian

# see the many curl executions:
# salmon-0.10.2$ find . -type f | xargs grep curl 2>/dev/null
