# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1 pypi

DESCRIPTION="Calculatine zarr checksums from local or cloud storage"
HOMEPAGE="https://github.com/dandi/zarr_checksum"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/zarr[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
