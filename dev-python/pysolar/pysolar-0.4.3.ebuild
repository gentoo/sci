# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils python

DESCRIPTION="A collection of Python libraries for simulating the Sun's irradiation"
HOMEPAGE="http://pysolar.org/ http://pypi.python.org/pypi/Pysolar/"
SRC_URI="https://github.com/pingswept/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="doc? ( dev-python/numpydoc )"
RDEPEND="
	dev-python/imaging
	dev-python/matplotlib
	dev-python/numpy
	dev-python/pygtk:2
	dev-python/pytz
	sci-libs/scipy"

S="${WORKDIR}"/pingswept-${PN}-a110543

PYTHON_MODNAME="constants.py horizon.py julian.py \
	poly.py query_usno.py radiation.py shade.py \
	simulate.py solar.py util.py"

src_prepare() {
	mv *${PN}* "${S}" && cd "${S}"
	sed \
		-e "s:'testsolar', ::" \
		-e "s:'shade_test', ::" \
		-i setup.py || die
}

src_compile() {
	distutils_src_compile

	if use doc; then
		cd doc
		PYTHONPATH=".." emake html || die
	fi
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/abi" "$(PYTHON)" testsolar.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r doc/.build/html/* || die
	fi
}
