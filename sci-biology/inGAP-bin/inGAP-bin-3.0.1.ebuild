# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PV="3_0_1"
S="${WORKDIR}"/inGAP_"${MY_PV}"

inherit java-utils-2

DESCRIPTION="Detect SNPs and indels from Next-gen sequences using a Bayesian algorithm"
HOMEPAGE="
	http://sites.google.com/site/nextgengenomics/ingap
	http://sourceforge.net/projects/ingap/"
SRC_URI="http://sourceforge.net/projects/ingap/files/ingap/v"${PV}"/inGAP_"${MY_PV}".tgz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jre-1.7:*"
RDEPEND="${DEPEND}
	dev-java/jfreechart
	dev-java/swing-layout
	dev-java/jcommon
	dev-java/itext
	dev-java/bytecode
	sci-biology/biojava
	dev-java/absolutelayout" # gnujaxp ?

src_install(){
	java-pkg_dojar inGAP.jar
	java-pkg_dolauncher inGAP --jar inGAP.jar
	# dobin external/bin/{primer3_core, run_cpp, trf}
	newdoc manual.pdf inGAP_Manual.pdf
	dodoc doc/manual.htm
	insinto /usr/share/inGAP/manual_files
	doins doc/manual_files/*.png
}
