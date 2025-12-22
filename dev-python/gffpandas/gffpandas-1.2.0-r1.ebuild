# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Python library to Filter and sort GFF3 annotations"
HOMEPAGE="https://github.com/foerstner-lab/gffpandas
	https://gffpandas.readthedocs.io/en/latest/"
SRC_URI="https://github.com/foerstner-lab/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pandas[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme

python_prepare_all() {
	# Do not depend on pytest-runner
	sed -i -e '/pytest-runner/d' setup.py || die

	distutils-r1_python_prepare_all
}
