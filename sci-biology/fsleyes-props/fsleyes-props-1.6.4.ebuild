# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

MY_PN="props"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="[wx]Python event programming framework"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/fsleyes/props/repository/${PV}/archive.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="
	=dev-python/six-1*
	=dev-python/numpy-1*
	>=dev-python/matplotlib-1.5.1
	<dev-python/matplotlib-3
	>=dev-python/wxpython-3.0.2.0
	<dev-python/wxpython-4.1
	dev-python/deprecation
	dev-python/sphinx
	>=sci-biology/fsleyes-widgets-0.6
	<sci-biology/fsleyes-widgets-1
	>=sci-biology/fslpy-1.4
	<sci-biology/fslpy-2
"
S="${WORKDIR}/${MY_P}-93b5cadc15da10a2e6ffacf1304edbb1c9a8355a"

src_compile() {
	python setup.py build
}

src_install() {
	python setup.py install --root "${D}"
}
