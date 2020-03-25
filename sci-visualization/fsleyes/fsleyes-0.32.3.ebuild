# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 desktop virtualx

DESCRIPTION="The new FSL image viewer, released with FSL 5.0.10"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/tree/master"
SRC_URI="
	https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/-/archive/${PV}/${P}.tar.gz
	https://github.com/pauldmccarthy/fsleyes/archive/${PV}.tar.gz -> ${P}.tar.gz
	"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		)
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

RDEPEND="
	>=dev-python/fslpy-1.13.2[${PYTHON_USEDEP}]
	=dev-python/jinja-2*[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.4.2[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyopengl_accelerate-3.1.0[${PYTHON_USEDEP}]
	=dev-python/pyparsing-2*[${PYTHON_USEDEP}]
	=dev-python/six-1*[${PYTHON_USEDEP}]
	>=dev-python/wxpython-3.0.2.0[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.18[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-visualization/fsleyes-widgets[${PYTHON_USEDEP}]
	sci-visualization/fsleyes-props[${PYTHON_USEDEP}]
	"
#=sci-libs/nibabel-2*[${PYTHON_USEDEP}]

PATCHES=(
	"${FILESDIR}/${PN}-0.26.2-fsldir.patch"
	"${FILESDIR}/${PN}-0.32.0-coverage.patch"
	"${FILESDIR}/${PN}-0.32.0-tests_timeout.patch"
	"${FILESDIR}/${PN}-0.32.0-tests_fail.patch"
	)

src_prepare() {
	sed -i -e "s/Pillow>=3.2.0,<6.0/Pillow>=3.2.0/g" requirements.txt
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	doicon userdoc/images/fsleyes_icon.png
	local size
	for size in 16 32 128 256 512 ; do
		doicon -s ${size} assets/icons/app_icon/${PN}.iconset/icon_${size}x${size}.png
	done
	make_desktop_entry fsleyes FSLeyes /usr/share/icons/hicolor/128x128/apps/icon_128x128.png
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}

python_test() {
	virtx pytest -vv || die
}
