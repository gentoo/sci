# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature

DESCRIPTION="Terminal spreadsheet multitool for discovering and arranging data"
HOMEPAGE="http://visidata.org"
SRC_URI="https://github.com/saulpw/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/odfpy[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-vcs/git
		$(python_gen_impl_dep sqlite)
	)
"

distutils_enable_tests pytest

python_test() {
	pytest -sv visidata/tests/
}

pkg_postinst() {
	optfeature "integration with yaml" >=dev-python/pyyaml-5.1
	optfeature "integration with pcap" dev-python/dnslib #dpkt pypcapkit
	optfeature "integration with png" dev-python/pypng
	optfeature "integration with http" dev-python/requests
	optfeature "integration with postgres" dev-python/psycopg-binary
	optfeature "integration with xlsx" dev-python/openpyxl
	optfeature "integration with xls" dev-python/xlrd
	optfeature "integration with hdf5" dev-python/h5py
	optfeature "integration with ttf/otf" dev-python/fonttools
	optfeature "integration with xml/htm/html" dev-python/lxml
	optfeature "integration with dta (Stata)" dev-python/pandas
	optfeature "integration with shapefiles" sci-libs/pyshp
	optfeature "integration with namestand" dev-python/graphviz
	optfeature "integration with pdfminer.six" dev-python/pdfminer-six # in guru
	optfeature "integration with vobject" dev-python/vobject
	optfeature "integration with tabulate" dev-python/tabulate
	optfeature "integration with tabulate (with unicode)" dev-python/wcwidth
	# optfeature "pdf tables" tabula # no package presently
	#optfeature "integration with mbtiles" mapbox-vector-tile
	#optfeature "integration with xpt (SAS)" xport
	#optfeature "integration with sas7bdat (SAS)" sas7bdat
	#optfeature "integration with sav (SPSS)" savReaderWriter
}
