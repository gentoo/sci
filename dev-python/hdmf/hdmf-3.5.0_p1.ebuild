# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1

MY_PV="${PV//_p*/}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The Hierarchical Data Modeling Framework"
HOMEPAGE="https://github.com/hdmf-dev/hdmf"
SRC_URI="https://github.com/hdmf-dev/hdmf/releases/download/${MY_PV}/${MY_P}.tar.gz"

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
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${MY_P}-open_links.patch"
)

distutils_enable_tests pytest

S="${WORKDIR}/${MY_P}"
