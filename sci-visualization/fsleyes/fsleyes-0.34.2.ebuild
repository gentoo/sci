# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit xdg distutils-r1 desktop virtualx

DESCRIPTION="The new FSL image viewer, released with FSL 5.0.10"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/tree/master"
SRC_URI="
	https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/-/archive/${PV}/${P}.tar.gz
	https://github.com/pauldmccarthy/fsleyes/archive/${PV}.tar.gz -> ${P}.tar.gz
	"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		)
	"

RDEPEND="
	>=dev-python/fslpy-3.1[${PYTHON_USEDEP}]
	=dev-python/jinja-2*[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl_accelerate-3.1.0[${PYTHON_USEDEP}]
	=dev-python/pyparsing-2*[${PYTHON_USEDEP}]
	=dev-python/six-1*[${PYTHON_USEDEP}]
	>=dev-python/wxpython-3.0.2.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.18[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.3[${PYTHON_USEDEP}]
	>=sci-visualization/fsleyes-widgets-0.8.4[${PYTHON_USEDEP}]
	>=sci-visualization/fsleyes-props-1.6.7[${PYTHON_USEDEP}]
	"

PATCHES=(
	"${FILESDIR}/${PN}-0.26.2-fsldir.patch"
	"${FILESDIR}/${PN}-0.32.0-tests_timeout.patch"
	"${FILESDIR}/${PN}-0.32.0-tests_fail.patch"
	)

distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on pytest-cov
	sed -i -e '/addopts/d' setup.cfg || die

	# Fatal Python error: Segmentation fault
	sed -i -e 's:test_crop:_&:' \
		tests/test_ortho_cropmode.py || die
	sed -i -e 's:test_fillSelection:_&:' \
		tests/test_ortho_editmode.py || die

	# KeyError: 'Unknown atlas ID: harvardoxford-cortical'
	sed -i -e 's:test_atlaspanel_toggleOverlay:_&:' \
		tests/test_atlaspanel.py || die

	# This hangs forever
	sed -i -e 's:test_lightbox:_&:' \
		tests/test_layouts.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	doicon userdoc/images/fsleyes_icon.png
	local size
	for size in 16 32 128 256 512 ; do
		newicon -s ${size} assets/icons/app_icon/${PN}.iconset/icon_${size}x${size}.png "${PN}.png"
	done
	make_desktop_entry fsleyes FSLeyes "${PN}"
}

python_test() {
	virtx pytest -vv || die
}
