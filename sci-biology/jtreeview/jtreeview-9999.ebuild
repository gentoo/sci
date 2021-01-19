# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module java-pkg-2 java-ant-2 git-r3

DESCRIPTION="Viewer for Microarray Data in PCL or CDT formats"
HOMEPAGE="http://jtreeview.sourceforge.net/" # no https
EGIT_REPO_URI="https://bitbucket.org/TreeView3Dev/treeview3.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND=">virtual/jdk-1.7:*"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

src_install(){
	java-pkg_dojar TreeView.jar
	java-pkg_dolauncher ${PN} TreeView.jar
	cd ../helper-scripts-0.0.2 || die
	perl_set_version
	insinto "${VENDOR_LIB}"
	doins *.pm
	dobin *.pl
	insinto /usr/share/"${PN}"/examples
	doins blues.color
	newdoc README README.helper-scripts
}
