# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Make-like task language"
HOMEPAGE="https://snakemake.readthedocs.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# cannot import name '_helpers' from 'google.cloud'
RESTRICT="test"

BDEPEND="
	dev-python/tomli[${PYTHON_USEDEP}]
	test? (
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/google-api-python-client[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pygraphviz[${PYTHON_USEDEP}]
		net-libs/google-cloud-cpp
	)
"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/immutables[${PYTHON_USEDEP}]
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	dev-python/connection_pool[${PYTHON_USEDEP}]
	dev-python/datrie[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/reretry[${PYTHON_USEDEP}]
	dev-python/smart-open[${PYTHON_USEDEP}]
	dev-python/snakemake-interface-executor-plugins[${PYTHON_USEDEP}]
	dev-python/snakemake-interface-common[${PYTHON_USEDEP}]
	dev-python/snakemake-interface-storage-plugins[${PYTHON_USEDEP}]
	dev-python/snakemake-interface-report-plugins[${PYTHON_USEDEP}]
	dev-python/stopit[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/throttler[${PYTHON_USEDEP}]
	dev-python/toposort[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/yte[${PYTHON_USEDEP}]
	dev-python/dpath[${PYTHON_USEDEP}]
	dev-python/conda-inject[${PYTHON_USEDEP}]
	sci-mathematics/pulp[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinxcontrib-napoleon \
	dev-python/sphinx-argparse \
	dev-python/sphinx-rtd-theme \
	dev-python/docutils \
	dev-python/recommonmark \
	dev-python/myst-parser
distutils_enable_tests pytest
