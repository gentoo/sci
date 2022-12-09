# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1 optfeature

DESCRIPTION="Python tools for geographic data"
HOMEPAGE="https://github.com/geopandas/geopandas"
SRC_URI="https://github.com/geopandas/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/shapely[${PYTHON_USEDEP}]
	dev-python/fiona[${PYTHON_USEDEP}]
	dev-python/pyproj[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# disable tests due to networking being blocked
		geopandas/io/tests/test_file.py::test_read_file_remote_zipfile_url
		geopandas/io/tests/test_file.py::test_read_file_remote_geojson_url
	)

	epytest ${deselect[@]/#/--deselect }
}

pkg_postinst() {
	optfeature "plotting" dev-python/matplotlib
	optfeature "spatial indexes and spatial joins" sci-libs/rtree
	optfeature "geocoding" sci-geosciences/geopy
}
