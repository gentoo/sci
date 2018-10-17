# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="FSLeyes, the FSL image viewer"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/repository/${PV}/archive.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="
	=dev-python/six-1*
	>=dev-python/numpy-1.14
	<dev-python/numpy-2
	>=dev-python/matplotlib-2.2.0
	<dev-python/matplotlib-3
	=sci-libs/nibabel-2*
	=dev-python/jinja-2*
	>=dev-python/pillow-3.2.0
	<dev-python/pillow-5.0
	>=dev-python/pyopengl-3.1.0
	<dev-python/pyopengl-4.0
	>=dev-python/pyopengl_accelerate-3.1.0
	<dev-python/pyopengl_accelerate-4.0
	=dev-python/pyparsing-2*
	>=sci-libs/scipy-0.18
	<sci-libs/scipy-2
	>=dev-python/wxpython-3.0.2.0
	<dev-python/wxpython-4.1
	dev-python/sphinx
	>=sci-biology/fslpy-1.11.0
	<sci-biology/fslpy-2
	>=sci-biology/fsleyes-props-1.6.2
	<sci-biology/fsleyes-props-2
	>=sci-biology/fsleyes-widgets-0.6
	<sci-biology/fsleyes-widgets-1
"

S="${WORKDIR}/${P}-af42b7efba43f60b9cc6d63009d9819dda8979d8"
