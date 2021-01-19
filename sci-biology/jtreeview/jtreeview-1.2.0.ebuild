# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module java-pkg-2 java-ant-2

DESCRIPTION="Viewer for Microarray Data in PCL or CDT formats"
HOMEPAGE="http://jtreeview.sourceforge.net/" # no https
SRC_URI="
	https://sourceforge.net/projects/jtreeview/files/jtreeview/${PV}/TreeView-${PV}-src.tar.gz
	https://sourceforge.net/projects/jtreeview/files/helper-scripts/0.0.2/helper-scripts-0.0.2.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">virtual/jdk-1.7:*
	dev-java/nanoxml"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}/TreeView-${PV}-src"
JAVA_PKG_BSFIX_NAME="${S}"

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
