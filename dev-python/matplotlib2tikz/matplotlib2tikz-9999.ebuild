# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 git-r3

DESCRIPTION="Convert matplotlib figures into TikZ/PGFPlots"
HOMEPAGE="https://github.com/nschloe/matplotlib2tikz"
EGIT_REPO_URI="https://github.com/nschloe/${PN}.git git://github.com/nschloe/${PN}.git"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}-0.6-init_pipdated.patch" )

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
	#test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
