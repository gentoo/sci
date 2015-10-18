# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

MY_PN="PythonQt"
MY_P="${MY_PN}${PV}"

DESCRIPTION="A dynamic Python binding for the Qt framework"
HOMEPAGE="http://pythonqt.sourceforge.net/"
SRC_URI="mirror://sourceforge/pythonqt/pythonqt/${MY_PN}-${PV}/${MY_P}_Qt4.8.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}_Qt4.8"

PATCHES=( "${FILESDIR}"/${P}-lib_location.patch )
EPATCH_OPTS="--binary"
