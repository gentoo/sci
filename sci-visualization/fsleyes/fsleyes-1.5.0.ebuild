# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_11 )
DISTUTILS_USE_PEP517=setuptools
inherit xdg distutils-r1 desktop virtualx

DESCRIPTION="The new FSL image viewer, released with FSL 5.0.10"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/tree/master"
SRC_URI="
	https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/-/archive/${PV}/${P}.tar.gz
	https://github.com/pauldmccarthy/fsleyes/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/fslpy-3.9[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.14[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-accelerate-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2[${PYTHON_USEDEP}]
	>=dev-python/wxpython-4[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.18[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.3[${PYTHON_USEDEP}]
	>=sci-visualization/fsleyes-widgets-0.12.3[${PYTHON_USEDEP}]
	>=sci-visualization/fsleyes-props-1.8[${PYTHON_USEDEP}]
	"

PATCHES=(
	"${FILESDIR}/${PN}-0.26.2-fsldir.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx userdoc dev-python/sphinx-rtd-theme

python_prepare_all() {
	# do not depend on pytest-cov
	sed -i -e '/addopts/d' setup.cfg || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	doicon -s 48 fsleyes/assets/linux/hicolor/48x48/apps/*.png
	domenu fsleyes/assets/linux/*.desktop
	insinto /usr/share/metainfo
	doins fsleyes/assets/linux/*.appdata.xml
	local size
	for size in 16 32 128 256 512 ; do
		newicon -s ${size} fsleyes/assets/icons/app_icon/${PN}.iconset/icon_${size}x${size}.png "${PN}.png"
	done
}

python_test() {
	virtx epytest
}
