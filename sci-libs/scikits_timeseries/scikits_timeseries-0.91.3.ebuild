# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_P="${P/scikits_/scikits.}"

DESCRIPTION="SciPy module for manipulating, reporting, and plotting time series"
HOMEPAGE="http://pytseries.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/pytseries/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/pytseries/${MY_P}-html_docs.zip )"

LICENSE="BSD eGenixPublic-1.0 eGenixPublic-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools
	dev-python/numpy
	doc? ( dev-python/sphinx )"
RDEPEND="sci-libs/scipy
	sci-libs/scikits
	dev-python/matplotlib
	dev-python/pytables"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" test
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	remove_scikits() {
		rm -f "${ED}"$(python_get_sitedir)/scikits/__init__.py || die
	}
	python_execute_function -q remove_scikits
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r "${WORKDIR}/html" || die
	fi
}
