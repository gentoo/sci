# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="pure-python fitting/limit-setting/interval estimation HistFactory-style"
HOMEPAGE="
	https://github.com/scikit-hep/pyhf
	https://doi.org/10.5281/zenodo.1169739
	https://zenodo.org/record/8256635
	https://doi.org/10.21105/joss.02823
	https://inspirehep.net/literature/2598491
	https://arxiv.org/abs/2211.15838
	https://doi.org/10.22323/1.414.0245
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# test needs missing scrapbook papermill pydocstyle ...
RESTRICT="test"

RDEPEND="
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/jsonpatch-1.15[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.15.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.56.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
