# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils java-pkg-2

DESCRIPTION="Analysis of residual dipolar couplings (RDCs) for structure validation and elucidation"
HOMEPAGE="http://ifestos.cse.sc.edu/software.php"
SRC_URI="http://ifestos.cse.sc.edu/downloads.php?get=Redcat.${PV}.tar.gz -> Redcat.${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-lang/tcl:*
	dev-tcltk/bwidget
	virtual/jdk:1.7
	"
DEPEND="${RDEPEND}
	virtual/jre:1.7
"

RESTRICT="fetch"

S="${WORKDIR}"/Redcat

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "http://ifestos.cse.sc.edu/downloads.php"
}

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	sed \
		-e '/BWidget/s:1.9.4:1.9.7:g' \
		-i scripts/REDCAT.tcl || die
	cmake-utils_src_prepare
	java-pkg-2_src_prepare
}

src_install() {
	cmake-utils_src_install

	java-pkg_dojar XplorGUI/XplorGUI.jar
	java-pkg_dolauncher XplorGUI --jar XplorGUI.jar

	dodoc Misc/REDCATManual.odt
	docompress -x /usr/share/doc/${PF}/REDCATManual.odt

	exeinto /usr/libexec/${PN}
	doexe scripts/*

	dosym ../libexec/${PN}/REDCAT.tcl /usr/bin/REDCAT.tcl
	dosym ../libexec/${PN}/MakeRedcat.tcl /usr/bin/MakeRedcat.tcl

	echo "${EPREFIX}/usr/share/redcat/" > conf/${PN}.conf
	insinto /usr/share/redcat/
	doins -r conf/${PN}.conf vmd data
}
