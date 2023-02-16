# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python module to support computational pipelines"
HOMEPAGE="http://www.ruffus.org.uk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: why does this not work: Duplicate pipeline
RESTRICT="test"

RDEPEND="
	media-gfx/graphviz
"

distutils_enable_sphinx doc dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
