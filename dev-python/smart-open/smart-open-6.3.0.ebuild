# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Utils for streaming large files (S3, HDFS, gzip, bz2...) "
HOMEPAGE="https://github.com/piskvorky/smart_open"
SRC_URI="https://github.com/piskvorky/smart_open/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN//-/_}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/google-cloud-storage[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		<dev-python/moto-5[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

RESTRICT="test" # 329 tests, 1 error: missing azure-storage-blob, azure-common[no ebuild], azure-core
distutils_enable_tests pytest
