# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib cmake-utils git-r3

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
EGIT_REPO_URI="https://github.com/COMBINE-lab/salmon.git"
# SRC_URI="https://github.com/COMBINE-lab/RapMap/archive/salmon-v0.10.2.zip -> ${PN}-0.10.2_RapMap.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-no-boost-static.patch
		"${FILESDIR}"/salmon-0.10.2_remove_curl_call.patch )

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
DEPEND="sys-libs/zlib
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
src_configure(){
	local mycmakeargs=(
		"-DBOOST_INCLUDEDIR=${EPREFIX}/usr/include/boost/"
		"-DBOOST_LIBRARYDIR=${EPREFIX}/usr/$(get_libdir)/"
		"-DTBB_INSTALL_DIR=${EPREFIX}/usr"
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
	)
	# BUG: the configure step runs automatically curl download of 3rd-party stuff
	# https://github.com/COMBINE-lab/salmon/issues/19
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -r "${ED}"/usr/tests || die
}
