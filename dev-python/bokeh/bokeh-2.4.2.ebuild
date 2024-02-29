# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 optfeature pypi

DESCRIPTION="Statistical and interactive HTML plots for Python"
HOMEPAGE="https://bokeh.org/"
SRC_URI+="
	https://raw.githubusercontent.com/bokeh/bokeh/${PV}/conftest.py -> conftest-${P}.py
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/jinja-2.9[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.11.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-16.8[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-5.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/ipython_genutils[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all(){
	cp "${DISTDIR}"/conftest-${P}.py "${S}"/conftest.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# disable tests having network calls
	local SKIP_TESTS=" \
		not (test___init__ and TestWarnings and test_filters) and \
		not (test_json__subcommands and test_no_script) and \
		not (test_standalone and Test_autoload_static) and \
		not test_nodejs_compile_javascript and \
		not test_nodejs_compile_less and \
		not test_inline_extension and \
		not (test_model and test_select) and \
		not test_tornado__server and \
		not test_client_server and \
		not test_webdriver and \
		not test_export and \
		not test_server and \
		not test_bundle and \
		not test_ext and \
		not test_detect_current_filename \
	"
	epytest -m "not sampledata" tests/unit -k "${SKIP_TESTS}"
}

pkg_postinst() {
	optfeature "integration with amazon S3" dev-python/boto
	optfeature "pypi integration to publish packages" dev-python/twine
	optfeature "js library usage" net-libs/nodejs
}
