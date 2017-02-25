# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit java-pkg-2 java-ant-2 eutils perl-module

S="${WORKDIR}"/TreeView-1.1.6r4-src

DESCRIPTION="Viewer for Microarray Data in PCL or CDT formats"
HOMEPAGE="http://jtreeview.sourceforge.net/"
SRC_URI="
	http://sourceforge.net/projects/jtreeview/files/jtreeview/1.1.6r4/TreeView-1.1.6r4-src.tar.gz
	http://sourceforge.net/projects/jtreeview/files/helper-scripts/0.0.2/helper-scripts-0.0.2.tar.gz"
#http://sourceforge.net/projects/jtreeview/files/jtreeview/1.1.6r4/TreeView-1.1.6r4-bin.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="" # resulting java binary does not execute for me
IUSE=""

DEPEND=">virtual/jdk-1.5:*
	dev-java/nanoxml"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*"

# TODO: use xltproc to create docs following TreeView-1.1.6r4-src/doc/README

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
