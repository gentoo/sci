# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{13..15} )

inherit distutils-r1 pypi

DESCRIPTION="Display Python session information and package versions"
HOMEPAGE="https://github.com/flying-sheep/session-info2"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/hatch-docstring-description[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# imports jupyter-client at collection time
		tests/test_subprocess.py
	)
	local EPYTEST_DESELECT=(
		# test expects itself installed
		tests/test_cli.py::test_cli
		# markdown padding is different on my system
		tests/test_synthetic.py::test_gpu
	)
	epytest
}
