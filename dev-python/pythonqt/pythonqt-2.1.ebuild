# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils

DESCRIPTION="A dynamic Python binding for the Qt framework."
HOMEPAGE="http://pythonqt.sourceforge.net/"
SRC_URI="mirror://sourceforge/pythonqt/pythonqt/PythonQt-2.1/PythonQt2.1_Qt4.8.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/PythonQt${PV}_Qt4.8"
CMAKE_BUILD_DIR="${S}"

src_prepare()
{
	use amd64 && epatch "${FILESDIR}/${P}-lib_location.patch"
}
