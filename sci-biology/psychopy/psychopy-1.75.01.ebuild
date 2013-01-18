# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"
DISTUTILS_SRC_TEST="py.test"

inherit distutils-r1 eutils

MY_P="PsychoPy-${PV}"

DESCRIPTION="Python experimental psychology toolkit"
HOMEPAGE="http://www.psychopy.org/"
SRC_URI="http://psychopy.googlecode.com/files/${MY_P}.zip"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/numpy[lapack]
        sci-libs/scipy
        dev-python/matplotlib
        dev-python/pyopengl[${PYTHON_USEDEP}]
        dev-python/imaging
        dev-python/wxpython
        dev-python/setuptools[${PYTHON_USEDEP}]
        dev-python/lxml[${PYTHON_USEDEP}]
        app-admin/eselect
        dev-python/pyglet
        dev-python/pygame"

DEPEND="app-arch/unzip
	dev-python/setuptools
	test? ( ${RDEPEND} )"

RESTRICT="test" # interactive, opens lots of windows

S="${WORKDIR}/${MY_P}"

python_install() {
	distutils-r1_python_install
	#local EPYTHON=python2.7
	#die $(sh -c 'echo $EPYTHON')
	fperms +x "$(python_get_sitedir)/psychopy/app/psychopyApp.py" || die "chmod of psychopyApp.py failed"
}
