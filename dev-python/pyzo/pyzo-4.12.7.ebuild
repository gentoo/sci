# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx desktop xdg

DESCRIPTION="The Python IDE for scientific computing"
HOMEPAGE="https://pyzo.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

# For some reason this requires network access
# Qt: Session management error: Could not open network socket
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/QtPy[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	test? (
		dev-python/visvis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc

python_prepare_all() {
	# Use relative path to avoid access violation
	# Do not install the license file, install other data_files manually
	sed -i \
		-e 's:/usr/share/metainfo:share/metainfo:g' \
		-e '/LICENSE.md/d' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	virtx epytest
}

python_install() {
	 distutils-r1_python_install
	 python_doscript pyzolauncher.py
}

python_install_all() {
	insinto /usr/share/metainfo/
	doins pyzo.appdata.xml

	for size in 16 32 48 64 128; do
		newicon -s ${size} "${PN}/resources/appicons/pyzologo${size}.png" pyzologo.png
	done
	domenu "${PN}/resources/${PN}.desktop"

	distutils-r1_python_install_all
}
