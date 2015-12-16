# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

MY_PN="pyFFTW"

DESCRIPTION="Peak detection utilities for 1D data"
HOMEPAGE="https://bitbucket.org/lucashnegri/peakutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
