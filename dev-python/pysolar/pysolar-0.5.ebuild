# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

AUTHOR=pingswept

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A collection of Python libraries for simulating the Sun's irradiation"
HOMEPAGE="http://pysolar.org/ http://pypi.python.org/pypi/Pysolar/"
SRC_URI="https://github.com/${AUTHOR}/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="doc? ( dev-python/numpydoc )"
RDEPEND="
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed \
		-e "s:'testsolar', ::" \
		-e "s:'shade_test', ::" \
		-i setup.py || die # don't install tests
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		PYTHONPATH=".." emake -C doc html
	fi
}

python_test() {
	${PYTHON} Pysolar/testsolar.py || die
}

python_install_all() {
	use doc && HTML_DOSC=( doc/.build/html/. )
	distutils-r1_python_install_all
}
