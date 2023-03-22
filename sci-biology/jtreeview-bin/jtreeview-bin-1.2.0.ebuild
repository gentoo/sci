# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2 perl-module

S="${WORKDIR}"/TreeView-1.1.6r4-bin

DESCRIPTION="Viewer for Microarray Data in PCL or CDT formats"
HOMEPAGE="https://jtreeview.sourceforge.net/"
SRC_URI="
	https://sourceforge.net/projects/jtreeview/files/jtreeview/${PV}/TreeView-${PV}-bin.tar.gz
	https://sourceforge.net/projects/jtreeview/files/helper-scripts/0.0.2/helper-scripts-0.0.2.tar.gz
"
S="${WORKDIR}/TreeView-${PV}-bin"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>virtual/jdk-1.5:*
"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5:*
"

# TODO: use xltproc to create docs following TreeView-1.1.6r4-src/doc/README

src_install(){
	java-pkg_dojar TreeView.jar
	java-pkg_dolauncher ${PN} TreeView.jar
	insinto /usr/share/"${PN}"/lib/plugins
	doins plugins/*.jar
	cd ../helper-scripts-0.0.2 || die
	perl_set_version
	perl_domodule *.pm
	perl_domodule *.pl
	insinto /usr/share/"${PN}"/examples
	doins blues.color
	newdoc README README.helper-scripts
}
