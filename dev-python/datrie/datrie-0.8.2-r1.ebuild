# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
# Fails to compile with pep517
#DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Implements a topological sort algorithm"
HOMEPAGE="https://github.com/pytries/datrie"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on pytest-runner
	sed -i "/pytest-runner/d" setup.py || die
	distutils-r1_python_prepare_all
}
