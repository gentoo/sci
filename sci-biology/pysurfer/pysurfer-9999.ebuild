# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Python based program for visualization of data from Freesurfer"
HOMEPAGE="http://pysurfer.github.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/PySurfer.git"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	sci-visualization/mayavi[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}/PySurfer-${PV}"
