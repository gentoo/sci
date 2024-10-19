# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Standards document describing ASDF, Advanced Scientific Data Format."
HOMEPAGE="
	https://github.com/asdf-format/asdf-standard/
	https://pypi.org/project/asdf-standard/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=dev-python/asdf-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-16.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
