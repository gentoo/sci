
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Routines for plotting area-weighted two- and three-circle venn diagrams"
HOMEPAGE="http://pysurfer.github.com"
SRC_URI="'mirror://pypi/m/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND=""
