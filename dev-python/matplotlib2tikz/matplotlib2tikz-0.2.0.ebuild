# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Python script for converting matplotlib figures into native Pgfplots (TikZ) figures"
HOMEPAGE="https://github.com/nschloe/matplotlib2tikz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}"-setup.py.patch
)

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-texlive/texlive-pictures"
DEPEND="${RDEPEND}"
	#test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
