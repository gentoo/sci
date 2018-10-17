# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="The FSL Python library"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsl/fslpy"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/fslpy/repository/${PV}/archive.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="
	=dev-python/six-1*
	dev-python/deprecation
	=dev-python/numpy-1*
	>=sci-libs/scipy-0.18
	<sci-libs/scipy-2
	=sci-libs/nibabel-2*
	>=dev-python/wxpython-3.0.2.0
	<dev-python/wxpython-4.1
"
S="${WORKDIR}/${P}-2575a60d0ba08c5cddc0eff83cbe6040b3efa994"
