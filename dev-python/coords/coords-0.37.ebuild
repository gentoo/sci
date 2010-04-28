# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="managing astronomical coordinate systems"
HOMEPAGE="https://www.stsci.edu/trac/ssb/astrolib/wiki"
SRC_URI="http://stsdas.stsci.edu/astrolib/${P}.tar.gz"

LICENSE="AURA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/numpy"
RESTRICT_PYTHON_ABIS="3.*"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" -c "import coords as C; print C._test()"
	}
	# FIX ME: test fail on amd64, reported upstream
	use amd64 || python_execute_function testing
}
