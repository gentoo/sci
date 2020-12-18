# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Simulated backend for PyVISA implementing TCPIP, GPIB, RS232, and USB resources"
HOMEPAGE="https://github.com/pyvisa/pyvisa"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/PyVISA[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/stringparser[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

python_prepare_all() {
	# correct testpaths
	sed -i -e 's/testpaths = pyvisa-sim\/testsuite/testpaths = pyvisa_sim\/testsuite/g' setup.cfg || die

	distutils-r1_python_prepare_all
}
