# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
HOMEPAGE="https://www.cs.cmu.edu/~ckingsf/software/sailfish/"
EGIT_REPO_URI="https://github.com/kingsfordgroup/sailfish.git"

LICENSE="GPL-3"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-0.9.2-no-boost-static.patch" )

DEPEND="
	dev-libs/boost:0
	dev-libs/jemalloc
	dev-libs/libdivsufsort
	dev-cpp/tbb
	sci-biology/jellyfish:2
"
RDEPEND="${DEPEND}"

# TODO: disable running wget/curl during src_compile
# https://github.com/kingsfordgroup/sailfish/issues/80
# contains bundled RapMap https://github.com/COMBINE-lab/RapMap
# contains bundled libdivsufsort
# contains bundled libgff https://github.com/COMBINE-lab/libgff
# contains bundled jellyfish-2.2.5
# contains bundled sparsehash-2.0.2

src_unpack() {
	default
	mkdir -p "${S}/external"
	cp "${DISTDIR}/quasi-mph.zip" "${S}/external/rapmap.zip" || die
	mkdir -p "${S}/external/install/lib"
	cp "${EPREFIX}/usr/$(get_libdir)/libdivsufsort.so" "${S}/external/install/lib/" || die
	cp "${EPREFIX}/usr/$(get_libdir)/libdivsufsort64.so" "${S}/external/install/lib/" || die
	cp "${EPREFIX}/usr/$(get_libdir)/libjellyfish-2.0.so" "${S}/external/install/lib/" || die
}

src_prepare() {
	cmake_src_prepare
	# use the dynamic library
	sed -i -e 's/libdivsufsort.a/libdivsufsort.so/g' \
		-e 's/libdivsufsort64.a/libdivsufsort64.so/g' \
		-e 's/libjellyfish-2.0.a/libjellyfish-2.0.so/g' \
		src/CMakeLists.txt || die

	# jellyfish2 instead of jellyfish
	pushd external/install/include/rapmap
	find -type f -name "*.hpp" -exec sed -i -e 's/jellyfish/jellyfish2/g' {} + || die
	popd
}

src_install() {
	cmake_src_install
	rm -r "${ED}"/usr/tests || die
	rm -f "${ED}"/usr/bin/jellyfish "${ED}"/usr/$(get_libdir)/libjellyfish || die
}
