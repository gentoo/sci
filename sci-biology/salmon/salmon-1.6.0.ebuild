# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Transcript-level quantification from RNA-seq reads using lightweight alignments"
HOMEPAGE="https://github.com/COMBINE-lab/salmon"
SRC_URI="
	https://github.com/COMBINE-lab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/COMBINE-lab/pufferfish/archive/salmon-v${PV}.tar.gz -> pufferfish-${P}.tar.gz
	https://github.com/COMBINE-lab/libgff/archive/v2.0.0.tar.gz -> libgff-${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	app-arch/bzip2
	app-arch/xz-utils
	>=dev-libs/jemalloc-5.0.1
	>=dev-cpp/tbb-2018.20180312
	dev-libs/cereal
	sci-libs/io_lib[static-libs]
"

BDEPEND="
	app-arch/unzip
	net-misc/curl
"

PATCHES=(
	"${FILESDIR}/${P}-find-boost.patch"
)

src_unpack() {
	default
	mkdir -p "${S}/external/install/lib" || die
	mv "${WORKDIR}/pufferfish-${PN}-v${PV}" "${S}/external/pufferfish" || die
	mv "${WORKDIR}/libgff-2.0.0" "${S}/external/libgff-2.0.0" || die
	ln -s "${EPREFIX}/usr/lib64/libtbb.so" "${S}/external/install/lib/libtbb.so" || die
	ln -s "${EPREFIX}/usr/lib64/libtbbmalloc.so" "${S}/external/install/lib/libtbbmalloc.so" || die
	ln -s "${EPREFIX}/usr/lib64/libtbbmalloc_proxy.so" "${S}/external/install/lib/libtbbmalloc_proxy.so" || die
}

src_prepare() {
	cmake_src_prepare
	sed -e 's:tbb/mutex.h:oneapi/tbb/mutex.h:g' \
		-i external/pufferfish/external/twopaco/graphconstructor/vertexenumerator.h \
		-i external/pufferfish/external/twopaco/common/streamfastaparser.h || die
}

src_configure() {
	local mycmakeargs=(
		-DFETCH_BOOST=FALSE
		-DBOOST_INCLUDEDIR="${EPREFIX}/usr/include/boost"
		-DBOOST_LIBRARYDIR="${EPREFIX}/usr/lib64"
		-DBoost_ALL_FOUND=TRUE
		-Dboost_headers_FOUND=TRUE
		-DBoost_FOUND=TRUE
	)
	cmake_src_configure
}
