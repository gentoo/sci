# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Managing astronomical coordinate systems"
HOMEPAGE="https://trac6.assembla.com/astrolib/wiki/ http://www.scipy.org/AstroLib/"
SRC_URI="http://stsdas.stsci.edu/astrolib/${P}.tar.gz"

LICENSE="AURA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/numpy"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" -c "import coords as C; print C._test()"
	}
	# FIX ME: test fail on amd64, reported upstream
	use amd64 || python_execute_function testing
}
