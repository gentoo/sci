# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit pypi distutils-r1

DESCRIPTION="Compatibility layer for NumPy to support the Array API"
HOMEPAGE="https://github.com/data-apis/array-api-compat"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

# relative import error, dev-python/jax ebuild not avail
RESTRICT="test"
distutils_enable_tests pytest
