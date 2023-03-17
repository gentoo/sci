# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Make-like task language"
HOMEPAGE="https://snakemake.readthedocs.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# missing test dep google.cloud
RESTRICT="test"

BDEPEND="test? (
	dev-python/requests-mock[${PYTHON_USEDEP}]
	dev-python/google-api-python-client[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/oauth2client[${PYTHON_USEDEP}]
	net-libs/google-cloud-cpp
)"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	dev-python/datrie[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ratelimit[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/toposort[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	sci-mathematics/pulp[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinxcontrib-napoleon \
	dev-python/sphinx-argparse \
	dev-python/sphinx_rtd_theme \
	dev-python/docutils \
	dev-python/recommonmark
distutils_enable_tests pytest
