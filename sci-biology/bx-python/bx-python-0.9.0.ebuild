# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )

inherit distutils-r1

DESCRIPTION="Library for rapid implementation of genome scale analyses"
HOMEPAGE="https://github.com/bxlab/bx-python"
SRC_URI="https://github.com/bxlab/bx-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Tests require dev-python/pytest-cython (currently not in ::gentoo or ::science)
# (and might need some more work beyond that)
RESTRICT=test

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

# has file collision with sci-biology/RSeQC

# ToDo: fix doc building:
# Reason: TemplateNotFound('i')
#distutils_enable_sphinx doc/source

distutils_enable_tests pytest
