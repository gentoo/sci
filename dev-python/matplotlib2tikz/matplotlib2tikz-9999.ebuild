# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 git-r3

DESCRIPTION="Python script for converting matplotlib figures into native Pgfplots (TikZ) figures"
HOMEPAGE="https://github.com/nschloe/matplotlib2tikz"
EGIT_REPO_URI="https://github.com/nschloe/${PN}.git git://github.com/nschloe/${PN}.git"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-texlive/texlive-pictures"
DEPEND="${RDEPEND}"
	#test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
