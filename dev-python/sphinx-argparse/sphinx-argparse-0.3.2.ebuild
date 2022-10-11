# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1

DESCRIPTION="Sphinx extension that automatically documents argparse commands and options"
HOMEPAGE="
	https://pypi.org/project/sphinx-argparse/
	https://github.com/ashb/sphinx-argparse
"
SRC_URI="https://github.com/ashb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
