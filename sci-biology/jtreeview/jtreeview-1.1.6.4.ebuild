# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

S="${WORKDIR}"/TreeView-1.1.6r4-src

DESCRIPTION="Viewer for Microarray Data in PCL or CDT formats"
HOMEPAGE="http://jtreeview.sourceforge.net/"
SRC_URI="
	http://sourceforge.net/projects/jtreeview/files/jtreeview/1.1.6r4/TreeView-1.1.6r4-src.tar.gz
	http://sourceforge.net/projects/jtreeview/files/helper-scripts/0.0.2/helper-scripts-0.0.2.tar.gz"
#http://sourceforge.net/projects/jtreeview/files/jtreeview/1.1.6r4/TreeView-1.1.6r4-bin.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/jdk:*"
RDEPEND="${DEPEND}
	virtual/jre:*"
