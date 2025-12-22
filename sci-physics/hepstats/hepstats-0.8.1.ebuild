# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Statistics tools and utilities."
HOMEPAGE="
	https://scikit-hep.org/hepstats/
	https://github.com/scikit-hep/hepstats
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # needs zfit

RDEPEND="
	dev-python/asdf[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/uhi[${PYTHON_USEDEP}]
"
