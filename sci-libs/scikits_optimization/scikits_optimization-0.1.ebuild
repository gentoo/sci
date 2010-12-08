# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_P="${P/scikits_/scikits.}"

DESCRIPTION="Python module for numerical optimization"
HOMEPAGE="http://projects.scipy.org/scipy/scikits"
SRC_URI="http://pypi.python.org/packages/source/s/scikits.optimization/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/numpy
	sci-libs/scikits"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="$(dir -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" test
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	remove_scikits() {
		rm -f "${ED}"$(python_get_sitedir)/scikits/__init__.py || die
	}
	python_execute_function -q remove_scikits
}
