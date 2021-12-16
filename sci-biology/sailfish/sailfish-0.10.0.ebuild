# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
HOMEPAGE="https://www.cs.cmu.edu/~ckingsf/software/sailfish/"
SRC_URI="https://github.com/kingsfordgroup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/COMBINE-lab/RapMap/archive/quasi-mph.zip
	https://github.com/gmarcais/Jellyfish/releases/download/v2.2.5/jellyfish-2.2.5.tar.gz
	https://github.com/COMBINE-lab/sparsehash/archive/sparsehash-2.0.2.tar.gz
	https://github.com/Kingsford-Group/libgff/archive/v1.0.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-libs/boost:0
	dev-libs/jemalloc
	dev-libs/libdivsufsort
	dev-cpp/tbb
	dev-cpp/sparsehash
	sci-biology/jellyfish:2
"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"
# a C++-11 compliant compiler is needs, aka >=gcc-4.7

# TODO: disable running wget/curl during src_compile
# https://github.com/kingsfordgroup/sailfish/issues/80
# contains bundled RapMap https://github.com/COMBINE-lab/RapMap
# contains bundled libdivsufsort
# contains bundled libgff https://github.com/COMBINE-lab/libgff
# contains bundled jellyfish-2.2.5
# contains bundled sparsehash-2.0.2

PATCHES=(
	"${FILESDIR}/${PN}-0.9.2-no-boost-static.patch"
	"${FILESDIR}/${PN}-no-curl.patch"
	"${FILESDIR}/${PN}-allow-newer-boost.patch"
)

src_unpack() {
	default
	mkdir -p "${S}/external"
	cp "${DISTDIR}/quasi-mph.zip" "${S}/external/rapmap.zip" || die
	mv "${WORKDIR}/RapMap-quasi-mph" "${S}/external/RapMap" || die
	mv "${WORKDIR}/jellyfish-2.2.5" "${S}/external/jellyfish-2.2.5" || die
	mv "${WORKDIR}/sparsehash-sparsehash-2.0.2" "${S}/external/sparsehash-sparsehash-2.0.2" || die
	mv "${WORKDIR}/libgff-1.0" "${S}/external/libgff" || die
	mkdir -p "${S}/external/install/lib"
	cp "${EPREFIX}/usr/$(get_libdir)/libdivsufsort.so" "${S}/external/install/lib/" || die
	cp "${EPREFIX}/usr/$(get_libdir)/libdivsufsort64.so" "${S}/external/install/lib/" || die
	cp "${EPREFIX}/usr/$(get_libdir)/libjellyfish-2.0.so" "${S}/external/install/lib/" || die
	mkdir -p "${S}/external/install/src/rapmap"
	cp "${S}/external/RapMap/src/"* "${S}/external/install/src/rapmap" || die
}

src_prepare() {
	cmake_src_prepare
	# use the dynamic library
	sed -i -e 's/libdivsufsort.a/libdivsufsort.so/g' \
		-e 's/libdivsufsort64.a/libdivsufsort64.so/g' \
		-e 's/libjellyfish-2.0.a/libjellyfish-2.0.so/g' \
		src/CMakeLists.txt || die
}

src_configure() {
	JELLYFISH_INCLUDE_DIR="/usr/include/jellyfish2" cmake_src_configure
	# jellyfish2 instead of jellyfish
	find -type f -name "*.hpp" -exec sed -i -e 's/#include \"jellyfish\//#include \"jellyfish2\//g' {} + || die
	find -type f -name "*.hpp" -exec sed -i -e 's/#include <jellyfish\//#include <jellyfish2\//g' {} + || die
}

src_install() {
	cmake_src_install
	rm -r "${ED}"/usr/tests || die
	rm -f "${ED}"/usr/bin/jellyfish "${ED}"/usr/$(get_libdir)/libjellyfish || die
}
