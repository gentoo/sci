# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit pypi distutils-r1

DESCRIPTION="Parse YAML configuration with environment variables in Python"
HOMEPAGE="https://pypi.org/project/pyaml-env/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

# tests not included in pypi tarball
RESTRICT="test"
#distutils_enable_tests pytest
