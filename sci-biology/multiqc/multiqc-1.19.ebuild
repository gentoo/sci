# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit pypi distutils-r1

DESCRIPTION="Aggregate bioinformatics results across many samples into a single report"
HOMEPAGE="https://multiqc.info/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/coloredlogs[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/lzstring[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/rich-click[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/spectra[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[$PYTHON_USEDEP]
	dev-python/humanize[$PYTHON_USEDEP]
	dev-python/pyaml-env[$PYTHON_USEDEP]"

# pypi tarball does not include tests
RESTRICT="test"
#distutils_enable_tests pytest
