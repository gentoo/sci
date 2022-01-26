# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Sphinx extension that automatically documents argparse commands and options"
HOMEPAGE="https://pypi.org/project/sphinx-argparse/
	https://github.com/ashb/sphinx-argparse"
SRC_URI="https://github.com/ashb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# requires self to build own documentation
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinx-argparse
