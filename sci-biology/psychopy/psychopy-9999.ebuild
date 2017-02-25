# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit eutils gnome2-utils distutils-r1 git-r3

DESCRIPTION="Python experimental psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/psychopy/psychopy.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/moviepy[${PYTHON_USEDEP}]
	dev-python/numpy[lapack,${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/wxpython:*[${PYTHON_USEDEP}]
	media-libs/avbin-bin
	media-libs/opencv[python,${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"

python_install_all() {
	distutils-r1_python_install_all
	newicon -s scalable psychopy/monitors/psychopy-icon.svg psychopy.svg
	make_desktop_entry psychopyApp.py PsychoPy psychopy
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
