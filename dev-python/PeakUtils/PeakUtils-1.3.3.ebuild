# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

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
