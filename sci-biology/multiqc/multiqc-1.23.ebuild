# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Aggregate bioinformatics results across many samples into a single report"
HOMEPAGE="https://multiqc.info/"
SRC_URI="https://github.com/MultiQC/MultiQC/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/MultiQC-${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0.0[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/pillow-10[${PYTHON_USEDEP}]
	>=dev-python/plotly-5.18[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-4[${PYTHON_USEDEP}]
	dev-python/pyaml-env[${PYTHON_USEDEP}]
	>=dev-python/rich-10[${PYTHON_USEDEP}]
	dev-python/rich-click[${PYTHON_USEDEP}]
	dev-python/coloredlogs[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=dev-python/spectra-0.0.10[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.7.1[${PYTHON_USEDEP}]
	dev-python/typeguard[${PYTHON_USEDEP}]"
#	dev-python/kaleido[${PYTHON_USEDEP}] # tested and is optional

RESTRICT="test" # no items collected
#distutils_enable_tests pytest
