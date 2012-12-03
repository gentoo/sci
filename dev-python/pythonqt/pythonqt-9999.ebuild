# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils subversion

DESCRIPTION="A dynamic Python binding for the Qt framework."
HOMEPAGE="http://pythonqt.sourceforge.net/"
ESVN_REPO_URI="https://pythonqt.svn.sourceforge.net/svnroot/pythonqt/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	use amd64 && epatch "${FILESDIR}/${P}-lib_location.patch"
}
