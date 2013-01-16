# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-2

DESCRIPTION="Python experiemntal psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
EGIT_REPO_URI="https://github.com/psychopy/psychopy"
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

python_install() {
	distutils-r1_python_install
	#local EPYTHON=python2.7
	#die $(sh -c 'echo $EPYTHON')
	chmod +x "${D}$(python_get_sitedir)/psychopy/app/psychopyApp.py" || die "chmod of psychopyApp.py failed"
}
