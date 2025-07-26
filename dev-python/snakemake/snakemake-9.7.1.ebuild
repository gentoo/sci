# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Make-like task language"
HOMEPAGE="https://snakemake.readthedocs.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/immutables[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	>=dev-python/connection_pool-0.0.3[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/referencing[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.1[${PYTHON_USEDEP}]
	dev-python/reretry[${PYTHON_USEDEP}]
	>=dev-python/smart-open-4.0[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-common-1.20.1[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-executor-plugins-9.3.2[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-storage-plugins-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-report-plugins-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/snakemake-interface-logger-plugins-1.1.0[${PYTHON_USEDEP}]
	dev-python/stopit[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/throttler[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	>=dev-python/yte-1.5.5[${PYTHON_USEDEP}]
	>=dev-python/dpath-2.1.6[${PYTHON_USEDEP}]
	>=dev-python/conda-inject-1.3.1[${PYTHON_USEDEP}]
	>=sci-mathematics/pulp-2.3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-assets.patch"
)

# distutils_enable_sphinx docs \
#	dev-python/sphinxcontrib-napoleon \
#	dev-python/sphinx-argparse \
#	dev-python/sphinx-rtd-theme \
#	dev-python/docutils \
#	dev-python/recommonmark \
#	dev-python/myst-parser

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# No module named 'snakemake_storage_plugin_s3'
		tests/tests.py::test_default_storage
		tests/tests.py::test_default_storage_local_job
		tests/tests.py::test_storage
		tests/tests.py::test_output_file_cache_storage
		tests/test_api.py::test_deploy_sources
		# No module 'snakemake-executor-plugin-cluster-generic'
		tests/tests.py::test_singularity_cluster
		tests/tests.py::test_group_jobs
		tests/tests.py::test_group_jobs_attempts
		tests/tests.py::test_groups_out_of_jobs
		tests/tests.py::test_global_resource_limits_limit_scheduling_of_groups
		tests/tests.py::test_new_resources_can_be_defined_as_local
		tests/tests.py::test_resources_can_be_overwritten_as_global
		tests/tests.py::test_group_job_resources_with_pipe_with_too_much_constraint
		tests/tests.py::test_multicomp_group_jobs
		tests/tests.py::test_group_job_fail
		tests/tests.py::test_issue850
		tests/tests.py::test_issue860
		tests/tests.py::test_job_properties
		tests/tests.py::test_issue930
		tests/tests.py::test_string_resources
		tests/tests.py::test_github_issue1158
		tests/tests.py::test_checkpoint_allowed_rules
		tests/tests.py::test_groupid_expand_cluster
		tests/tests.py::test_storage_localrule
		tests/tests.py::test_storage_cleanup_local
		tests/tests.py::test_scopes_submitted_to_cluster
		tests/tests.py::test_resources_submitted_to_cluster
		tests/tests.py::test_excluded_resources_not_submitted_to_cluster
		tests/tests.py::test_group_job_resources_with_pipe
		tests/tests.py::test_nodelocal
		tests/tests.py::test_access_patterns
		tests/tests.py::test_resource_quoting_profile
		tests/tests.py::test_resource_quoting_cli
		tests/tests.py::test_default_resource_quoting_cli
		tests/tests.py::test_default_resource_quoting_profile
		# Missing snakemake-storage-plugin-http
		tests/tests.py::test_ancient
		tests/tests.py::test_modules_prefix
		tests/tests.py::test_keep_local
		tests/tests.py::test_retrieve
		# Missing snakemake-storage-plugin-fs
		tests/tests.py::test_handle_storage_multi_consumers
		tests/tests.py::test_checkpoint_open
		# Missing python-polars
		tests/tests.py::test_params_pickling
		tests/tests.py::test_validate
		# requires singularity and does not skip
		tests/tests.py::test_singularity
		tests/tests.py::test_cwl_singularity
		tests/tests.py::test_shell_exec
		# requires 'stress-ng' in $PATH
		tests/tests.py::test_benchmark
		tests/tests.py::test_benchmark_jsonl
		# requires 'dot' bash module
		tests/tests.py::test_env_modules
		# requires python-peppy
		tests/tests.py::test_modules_peppy
		tests/tests.py::test_peppy
		tests/tests.py::test_pep_pathlib
		# specifies CLI call --snakefile in spaced dir without quoting
		tests/tests.py::test_with_parentheses
		# missing .bashrc
		tests/tests.py::test_strict_mode
		# creates directory with chmod 000, breaks portage cleanup
		tests/tests.py::test_github_issue640
		# missing jupyter
		tests/tests.py::test_jupyter_notebook
		tests/tests.py::test_jupyter_notebook_nbconvert
		tests/tests.py::test_jupyter_notebook_draft
	)

	epytest -W ignore::ResourceWarning \
		tests/tests.py \
		tests/test_expand.py \
		tests/test_io.py \
		tests/test_schema.py \
		tests/test_api.py
}
