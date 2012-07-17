# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils mercurial

DESCRIPTION="Astrophysical Simulation Analysis and Vizualization package"
HOMEPAGE="http://yt-project.org/"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/yt_analysis/yt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="media-libs/freetype
	media-libs/libpng
	sci-libs/hdf5"
DEPEND="${CDEPEND}
	dev-python/cython
	dev-python/setuptools"
RDEPEND="${CDEPEND}
	dev-python/ipython[notebook]
	dev-python/pyx
	dev-python/numpy
	dev-python/h5py
	dev-python/matplotlib"

pkg_setup() {
	export PNG_DIR="${EPREFIX}"/usr
	export FTYPE_DIR="${EPREFIX}"/usr
	export HDF5_DIR="${EPREFIX}"/usr
	python_pkg_setup
}
