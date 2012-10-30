# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils distutils
MY_P="PsychoPy-${PV}"

DESCRIPTION="Python experiemntal psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
SRC_URI="http://psychopy.googlecode.com/files/PsychoPy-1.75.01.zip"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip
	dev-python/numpy[lapack]
        sci-libs/scipy
        dev-python/matplotlib
        dev-python/pyopengl
        dev-python/imaging
        dev-python/wxpython
        dev-python/setuptools
        dev-python/lxml"

RDEPEND="${DEPEND}
        app-admin/eselect
        dev-python/pyglet
        dev-python/pygame
        "

S="${WORKDIR}/${MY_P}"
