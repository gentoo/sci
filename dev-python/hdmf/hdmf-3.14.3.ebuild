# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="The Hierarchical Data Modeling Framework"
HOMEPAGE="https://github.com/hdmf-dev/hdmf"
SRC_URI="$(pypi_sdist_url hdmf)"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	"

#PATCHES=(
#	"${FILESDIR}/${PN}-3.11.0-no_test_coverage.patch"
#	)

distutils_enable_tests pytest
