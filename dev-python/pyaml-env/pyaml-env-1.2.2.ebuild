# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Parse YAML configuration with environment variables in Python"
HOMEPAGE="https://pypi.org/project/pyaml-env/"
SRC_URI="https://github.com/mkaranasou/pyaml_env/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/pyaml_env-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
