# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Terminal spreadsheet multitool for discovering and arranging data"
HOMEPAGE="http://visidata.org"
SRC_URI="https://github.com/saulpw/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Reported upstream:
# https://github.com/saulpw/visidata/issues/1905
RESTRICT="test"

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

#distutils_enable_sphinx docs \
#	dev-python/recommonmark \
#	dev-python/sphinx-argparse
# dev-python/sphinx-markdown-tables

distutils_enable_tests pytest

python_prepare_all() {
	rm tests/load-http.vd || die "Could not remove network-dependent test."
	rm tests/graph-cursor-nosave.vd || die "Could not remove network-dependent test."
	rm tests/messenger-nosave.vd || die "Could not remove network-dependent test."
	rm tests/save-benchmarks.vd || die "Could not benchmarks test"
	rm tests/graphpr-nosave.vd || die "Could not benchmarks test"
	rm tests/describe-error.vd || die "Could not remove network-dependent test"
	rm tests/describe.vd || die "Could not remove network-dependent test"
	rm tests/edit-type.vd || die "Could not remove network-dependent test"

	distutils-r1_python_prepare_all
}

python_test() {
	git init || die "Git init failed."
	git add tests/golden/ || die "Git add failed."
	# this test script eventually calls pytest under the hood
	dev/test.sh || die "Tests failed."
	rm .git -rf || die "Could not clean up git test directory."
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
