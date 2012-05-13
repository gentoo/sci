# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"

inherit distutils

DESCRIPTION="Simple cosmology python module"
HOMEPAGE="http://cxc.harvard.edu/contrib/cosmocalc/ http://pypi.python.org/pypi/cosmocalc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	distutils_src_prepare

	2to3_conversion() {
		[[ "${PYTHON_ABI}" == 2.* ]] && return
		2to3-${PYTHON_ABI} -nw --no-diffs ${PN}.py
	}
	python_execute_function -s 2to3_conversion
}
