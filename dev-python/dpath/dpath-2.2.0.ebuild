# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit pypi distutils-r1

DESCRIPTION="Accessing and searching dictionaries via /slashed/paths"
HOMEPAGE="https://pypi.org/project/dpath/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/nose2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
