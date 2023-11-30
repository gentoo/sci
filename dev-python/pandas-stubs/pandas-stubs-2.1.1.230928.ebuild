# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Public type stubs for pandas"
HOMEPAGE="https://github.com/pandas-dev/pandas-stubs"
SRC_URI="https://github.com/pandas-dev/pandas-stubs/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# Allegedly also needs dev-python/types-pytz (available in ::guru), but somehow works without it...
# https://github.com/pandas-dev/pandas-stubs/blob/3c2affdaeb1cb03777cc59832dcdd4b030add27d/pyproject.toml#L34
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/xarray[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Package has a bunch of test deps missing from ::gentoo and ::science
	tests/test_frame.py::test_to_markdown
	tests/test_frame.py::test_types_to_feather
	tests/test_io.py::test_orc
	tests/test_io.py::test_orc_path
	tests/test_io.py::test_orc_buffer
	tests/test_io.py::test_orc_columns
	tests/test_io.py::test_orc_bytes
	tests/test_io.py::test_hdf
	tests/test_io.py::test_hdfstore
	tests/test_io.py::test_read_hdf_iterator
	tests/test_io.py::test_hdf_context_manager
	tests/test_io.py::test_hdf_series
	tests/test_io.py::test_spss
	tests/test_io.py::test_parquet
	tests/test_io.py::test_parquet_options
	tests/test_io.py::test_excel_writer_engine
	tests/test_io.py::test_all_read_without_lxml_dtype_backend
	tests/test_series.py::test_types_agg
	tests/test_series.py::test_types_aggregate
)

distutils_enable_tests pytest
