# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 multiprocessing

DESCRIPTION="Python library for Apache Arrow"
SRC_URI="mirror://apache/arrow/arrow-${PV}/apache-arrow-${PV}.tar.gz"
HOMEPAGE="https://arrow.apache.org/"

IUSE="+parquet +dataset"
REQUIRED_USE="dataset? ( parquet )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/apache-arrow-${PV}/python"
RESTRICT="test" # tests seems not working

BDEPEND="dev-util/cmake"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~dev-libs/apache-arrow-${PV}[csv,json,parquet?,snappy]
"
DEPEND="${RDEPEND}"

src_compile() {
	export PYARROW_WITH_PARQUET=$(usex parquet "ON" "")
	export PYARROW_WITH_DATASET=$(usex dataset "ON" "")
	local jobs=$(makeopts_jobs "${MAKEOPTS}" INF)
	export PYARROW_PARALLEL="${jobs}"
	export PYARROW_BUILD_VERBOSE="1"
	export PYARROW_BUNDLE_ARROW_CPP_HEADERS=0
	export PYARROW_CMAKE_GENERATOR=Ninja
	distutils-r1_src_compile
}
