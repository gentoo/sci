# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1

DESCRIPTION="Simple cosmology python module"
HOMEPAGE="http://cxc.harvard.edu/contrib/cosmocalc/ http://pypi.python.org/pypi/cosmocalc/"
SRC_URI="http://cxc.harvard.edu/contrib/cosmocalc/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

python_compile() {
	distutils-r1_python_compile
	[[ "${PYTHON}" =~ python2 ]] && return
	2to3 -nw --no-diffs "${BUILD_DIR}" || die
}
