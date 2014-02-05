# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_2 python3_3 )

inherit distutils-r1 git-r3

DESCRIPTION="Custom Matplotlib Axes class for displaying astronomical fits images"
HOMEPAGE="http://leejjoon.github.io/pywcsgrid2/"
EGIT_REPO_URI="https://github.com/leejjoon/pywcsgrid2.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	|| ( dev-python/pyfits[${PYTHON_USEDEP}] dev-python/astropy[${PYTHON_USEDEP}] )
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	virtual/pywcs[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
