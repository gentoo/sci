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

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/immutables[${PYTHON_USEDEP}]
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	>=dev-python/connection_pool-0.0.3[${PYTHON_USEDEP}]
	dev-python/datrie[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.1[${PYTHON_USEDEP}]
	dev-python/reretry[${PYTHON_USEDEP}]
	>=dev-python/smart-open-4.0[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-common-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-executor-plugins-9.3.2[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-storage-plugins-3.2.3[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-report-plugins-1.1.0[${PYTHON_USEDEP}]
	dev-python/stopit[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/throttler[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	>=dev-python/yte-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/dpath-2.1.6[${PYTHON_USEDEP}]
	>=dev-python/conda-inject-1.3.1[${PYTHON_USEDEP}]
	>=sci-mathematics/pulp-2.3.1[${PYTHON_USEDEP}]
"

# distutils_enable_sphinx docs \
# 	dev-python/sphinxcontrib-napoleon \
# 	dev-python/sphinx-argparse \
# 	dev-python/sphinx-rtd-theme \
# 	dev-python/docutils \
# 	dev-python/recommonmark \
# 	dev-python/myst-parser

EPYTEST_IGNORE=(
	# __file__ attribute does not match test name ('python_3_7')
	tests/test_conda_python_3_7_script/test_script.py
	# ModuleNotFoundError: No module named 'snakemake_executor_plugin_cluster_generic'
	tests/test_executor_test_suite.py
	# ImportError: cannot import name 'snakemake' from 'snakemake.script'
	tests/test_script_py/scripts/test_explicit_import.py
)
EPYTEST_DESELECT=(
	# No module named 'snakemake_storage_plugin_s3'
	tests/test_api.py::test_deploy_sources
)
distutils_enable_tests pytest
