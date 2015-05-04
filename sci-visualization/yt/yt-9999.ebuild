# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
EHG_REPO_URI="https://bitbucket.org/yt_analysis/yt"
EHG_REVISION="yt"

inherit distutils-r1 mercurial

DESCRIPTION="Astrophysical Simulation Analysis and Vizualization package"
HOMEPAGE="http://yt-project.org/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="test"

CDEPEND="media-libs/freetype
	media-libs/libpng
	sci-libs/hdf5"
RDEPEND="${CDEPEND}
	dev-python/ipython[notebook,${PYTHON_USEDEP}]
	dev-python/pyx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
    dev-python/Forthon[${PYTHON_USEDEP}]
	>=dev-python/cython-0.19[${PYTHON_USEDEP}]
	>=dev-python/setuptools-0.7[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
    )"

# TODO
#python_test() {
#	nosetests || die
#}
