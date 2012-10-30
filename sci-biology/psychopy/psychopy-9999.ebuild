# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils distutils git-2

DESCRIPTION="Python experiemntal psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
EGIT_REPO_URI="https://github.com/psychopy/psychopy"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/numpy[lapack]
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
