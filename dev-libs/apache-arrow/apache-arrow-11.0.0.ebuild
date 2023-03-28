# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

IUSE="+bzip2 +brotli +csv +lz4 +parquet snappy test +zlib +zstd"

DESCRIPTION="A cross-language development platform for in-memory data."
HOMEPAGE="https://arrow.apache.org/"
PARQUET_DATA_GIT_HASH=b2e7cc755159196e3a068c8594f7acbaecfdaaac
ARROW_DATA_GIT_HASH=d2c73bf78246331d8e58b6f11aa8aa199cbb5929
SRC_URI="mirror://apache/arrow/arrow-${PV}/${P}.tar.gz
test? ( https://github.com/apache/parquet-testing/archive/${PARQUET_DATA_GIT_HASH}.tar.gz -> ${PN}-parquet-data-${PV}.tar.gz
	https://github.com/apache/arrow-testing/archive/${ARROW_DATA_GIT_HASH}.tar.gz -> ${PN}-arrow-data-${PV}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/lz4
	>=dev-cpp/xsimd-8.1
	lz4? ( app-arch/lz4:= )
	brotli? ( app-arch/brotli )
	bzip2? ( app-arch/bzip2 )
	parquet? (
		dev-libs/libutf8proc:=
		dev-libs/re2:=
		dev-libs/thrift
	)
	snappy? ( app-arch/snappy )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${RDEPEND}
	dev-libs/rapidjson
	net-libs/grpc
	>=dev-cpp/xsimd-8.1
	test? (
		dev-libs/flatbuffers
		dev-cpp/gflags
		dev-cpp/gtest
	)
"

S="${WORKDIR}/${P}/cpp"

PATCHES=( "${FILESDIR}/arrow-11.0-shared-lz4.patch" )

src_prepare() {
	# use Gentoo CXXFLAGS, specify docdir at src_configure.
	sed -e '/SetupCxxFlags/d' \
		-e '/set(ARROW_DOC_DIR.*)/d' \
		-i CMakeLists.txt || die
	# xsimd version is managed by Gentoo.
	sed -e 's/resolve_dependency(xsimd.*)/resolve_dependency(xsimd)/' \
		-i cmake_modules/ThirdpartyToolchain.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DARROW_DEPENDENCY_SOURCE=SYSTEM
		-DARROW_BUILD_STATIC=OFF
		-DARROW_CSV=$(usex csv ON OFF)
		-DARROW_DATASET=ON
		-DARROW_DOC_DIR=share/doc/${PF}
		-DARROW_JEMALLOC=OFF
		-DARROW_SUBSTRAIT=OFF
		-DARROW_BUILD_TESTS=$(usex test ON OFF)
		-DARROW_MIMALLOC=OFF
		-DARROW_PARQUET=$(usex parquet ON OFF)
		-DARROW_WITH_BZ2=$(usex bzip2 ON OFF)
		-DARROW_WITH_LZ4=$(usex lz4 ON OFF)
		-DARROW_WITH_SNAPPY=$(usex snappy ON OFF)
		-DARROW_WITH_ZLIB=$(usex zlib ON OFF)
		-DARROW_WITH_ZSTD=$(usex zstd ON OFF)
	)
	cmake_src_configure
}

src_test() {
	export PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	export ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
	cmake_src_test
}
