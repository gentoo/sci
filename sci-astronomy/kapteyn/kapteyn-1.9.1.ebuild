# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Collection of python tools for astronomy"
HOMEPAGE="http://www.astro.rug.nl/software/kapteyn"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	sci-astronomy/wcslib
	dev-python/numpy"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

src_install() {
	distutils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die
	fi
}
