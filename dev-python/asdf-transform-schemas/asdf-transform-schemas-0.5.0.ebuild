# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="ASDF schemas for validating transform tags."
HOMEPAGE="
	https://github.com/asdf-format/asdf-transform-schemas/
	https://pypi.org/project/asdf-transform-schemas/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # needs asdf-astropy

RDEPEND="
	>=dev-python/asdf-standard-1.1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
