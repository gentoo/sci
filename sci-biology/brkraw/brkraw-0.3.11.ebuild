# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="https://github.com/BrkRaw/brkraw"
SRC_URI="https://github.com/BrkRaw/brkraw/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# Strange test infrastructure involving dynamic download via make:
# https://github.com/BrkRaw/brkraw/blob/main/.github/workflows/test.yml
RESTRICT="test"

RDEPEND="
	>=dev-python/numpy-1.18[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.1.1[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.45.0[${PYTHON_USEDEP}]
	>=dev-python/openpyxl-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/xlrd-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/pandas-1[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-3.0.2[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-testexclusion.patch" )

distutils_enable_tests pytest
