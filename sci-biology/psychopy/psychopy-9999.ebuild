# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-2

DESCRIPTION="Python experiemntal psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
EGIT_REPO_URI="https://github.com/psychopy/psychopy.git"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	app-admin/eselect
	dev-python/imaging
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/matplotlib
	dev-python/numpy[lapack]
        dev-python/pygame
	dev-python/pyglet
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/wxpython
	sci-libs/scipy"

src_install() {
        distutils-r1_src_install
        newicon -s scalable psychopy/monitors/psychopy-icon.svg psychopy.svg
        make_desktop_entry psychopyApp.py PsychoPy psychopy "Science;Biology"
}

pkg_postinst() {
	touch "${ROOT}/usr/share/icons/hicolor"
}
