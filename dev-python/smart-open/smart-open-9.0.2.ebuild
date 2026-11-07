# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="Utils for streaming large files (S3, HDFS, gzip, bz2...)"
HOMEPAGE="https://github.com/piskvorky/smart_open"
SRC_URI="https://github.com/piskvorky/smart_open/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN//-/_}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/backports-zstd[${PYTHON_USEDEP}]' python3_{12..13})
		dev-python/lz4[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# requires google-cloud-storage
		tests/test_gcs.py
		# requires unpackaged Azure SDK dependencies
		tests/test_azure.py
		tests/test_closed.py
		tests/test_readline.py
		# requires Moto's S3 test backend
		tests/test_s3.py
		tests/test_s3_version.py
		tests/test_smart_open.py
	)

	epytest -o addopts= tests
}
