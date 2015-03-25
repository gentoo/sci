# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="pyFFTW"

DESCRIPTION="FFTW wrapper for python"
HOMEPAGE="http://hgomersall.github.io/pyFFTW/"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hgomersall/${MY_PN}.git git://github.com/hgomersall/${MY_PN}.git"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	>=sci-libs/fftw-3.3.3
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
