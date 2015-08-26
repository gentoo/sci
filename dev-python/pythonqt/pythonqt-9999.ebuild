# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 subversion

MY_PN="PythonQt"
MY_P="${MY_PN}${PV}"

DESCRIPTION="A dynamic Python binding for the Qt framework"
HOMEPAGE="http://pythonqt.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="https://pythonqt.svn.sourceforge.net/svnroot/pythonqt/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-lib_location.patch )
EPATCH_OPTS="--binary"

src_prepare() {
	subversion_src_prepare
	cmake-utils_src_prepare
}
