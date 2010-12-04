# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_P="${P/scikits_/scikits.}"

DESCRIPTION="Statistical computations and models for use with SciPy"
HOMEPAGE="http://scikits.appspot.com/statsmodels"
SRC_URI="http://pypi.python.org/packages/source/s/scikits.statsmodels/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="sci-libs/scipy
	sci-libs/scikits"
DEPEND="dev-python/numpy
	dev-python/setuptools
	doc? ( dev-python/sphinx )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# remove badly placed docs and examples
	sed -i \
		-e '/statsmodels\/docs/d' \
		-e '/statsmodels\/examples/d' \
		setup.py || die
	mv scikits/statsmodels/{docs,examples} .
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	if use doc; then
		"$(PYTHON -f)" setup.py build_sphinx || die "Generation of documentation failed"
	fi
}

src_test() {
	testing() {
		PYTHONPATH="$(dir -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" test
	}
	python_execute_function testing
}

src_install() {
	find "${S}" -name \*LICENSE.txt -delete
	distutils_src_install
	remove_scikits() {
		rm -f "${ED}"$(python_get_sitedir)/scikits/__init__.py || die
	}
	python_execute_function -q remove_scikits
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins -r build/sphinx/html || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
