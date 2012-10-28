# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils distutils git-2

DESCRIPTION="Python psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
EGIT_REPO_URI="https://github.com/psychopy/psychopy"
LICENSE="GNU GPL v3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test doc"

DEPEND="dev-python/numpy[lapack]
	sci-libs/scipy
	dev-python/matplotlib
	dev-python/pyopengl
	dev-python/imaging
	dev-python/wxpython
	dev-python/setuptools
	dev-python/lxml"


# Run-time dependencies. Must be defined to whatever this depends on to run.
# The below is valid if the same run-time depends are required to compile.
RDEPEND="app-admin/eselect
	dev-python/numpy[lapack]       
	sci-libs/scipy
        dev-python/matplotlib
        dev-python/pyglet
        dev-python/pygame
        dev-python/pyopengl
        dev-python/imaging
        dev-python/wxpython
        dev-python/setuptools
        dev-python/lxml"

S="${WORKDIR}/psychopy/"
