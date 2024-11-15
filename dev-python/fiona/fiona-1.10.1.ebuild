# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="API for reading/writing vector geospatial data"
HOMEPAGE="https://github.com/Toblerity/fiona"
SRC_URI="https://github.com/Toblerity/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/Fiona-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/gdal[geos,sqlite]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/click-plugins[${PYTHON_USEDEP}]
	dev-python/cligj[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		sci-libs/gdal[geos,sqlite]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# disable tests violating network sandbox
		tests/test_vfs.py::test_open_http
		tests/test_vfs.py::test_open_zip_https
		tests/test_collection.py::test_collection_http
		tests/test_collection.py::test_collection_zip_http

		# disable tests failing due to deprecated GDAL features
		tests/test_data_paths.py::test_gdal_data_wheel
		tests/test_data_paths.py::test_proj_data_wheel
		tests/test_data_paths.py::test_env_gdal_data_wheel
		tests/test_data_paths.py::test_env_proj_data_wheel
		tests/test_datetime.py::test_datefield[GPSTrackMaker-datetime]
		tests/test_datetime.py::test_datefield_null[GPSTrackMaker-datetime]
		tests/test_drvsupport.py::test_write_or_driver_error[GPSTrackMaker]
		tests/test_drvsupport.py::test_no_append_driver_cannot_append[GPSTrackMaker]
		tests/test_drvsupport.py::test_no_append_driver_cannot_append[PCIDSK]
		tests/test_drvsupport.py::test_write_or_driver_error[DGN]

		# OGR silently fails to convert strings
		tests/test_unicode.py::TestUnicodeStringField::test_write_mismatch
	)

	mv fiona{,.bak} || die # Avoid non-working local import
	epytest
	mv fiona{.bak,} || die
}
