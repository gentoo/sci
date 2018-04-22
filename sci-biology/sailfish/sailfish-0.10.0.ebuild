# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
HOMEPAGE="http://www.cs.cmu.edu/~ckingsf/software/sailfish/"
SRC_URI="https://github.com/kingsfordgroup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-0.9.2-no-boost-static.patch )

DEPEND="dev-libs/boost:0
		dev-libs/jemalloc
		dev-cpp/tbb
		sci-biology/jellyfish:2"
RDEPEND="${DEPEND}"
# a C++-11 compliant compiler is needs, aka >=gcc-4.7

# TODO: disable running wget/curl during src_compile
# https://github.com/kingsfordgroup/sailfish/issues/80
# contains bundled RapMap https://github.com/COMBINE-lab/RapMap
# contains bundled libdivsufsort
# contains bundled libgff https://github.com/COMBINE-lab/libgff
# contains bundled jellyfish-2.2.5
# contains bundled sparsehash-2.0.2

src_install() {
	cmake-utils_src_install
	rm -r "${ED}"/usr/tests || die
	rm -f "${ED}"/usr/bin/jellyfish "${ED}"/usr/$(get_libdir)/libjellyfish || die
}
