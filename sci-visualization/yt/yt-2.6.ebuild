# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1 flag-o-matic

DESCRIPTION="Astrophysical Simulation Analysis and Vizualization package"
HOMEPAGE="http://yt-project.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND="media-libs/freetype:2
	media-libs/libpng:0=
	sci-libs/hdf5:="
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

python_prepare_all() {
	append-flags -fno-strict-aliasing
	sed -i setup.py \
		-e 's:build/lib:../../../&:' || die
	sed -i yt/utilities/setup.py \
		-e "s:/usr:${EPREFIX}/usr:g"  || die
	mv yt/utilities/kdtree/fKD.{f,F}90 || die # Forthon-0.8.13
	distutils-r1_python_prepare_all
}

# TODO
#python_test() {
#	nosetests || die
#}
