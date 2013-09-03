# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils eutils

MY_P="PsychoPy-${PV}"

DESCRIPTION="Python experimental psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
SRC_URI="http://psychopy.googlecode.com/files/${MY_P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/numpy[lapack,${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	"

DEPEND="app-admin/eselect
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
	"

RESTRICT="test" # interactive, opens lots of windows

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all
	doicon psychopy/monitors/psychopy.ico
	make_desktop_entry psychopyapp.py PsychoPy psychopy
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
