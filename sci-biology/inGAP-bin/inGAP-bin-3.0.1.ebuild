# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MY_PV="3_0_1"
S="${WORKDIR}"/inGAP_"${MY_PV}"

DESCRIPTION="Detect SNPs and indels from Next-gen sequences using a Bayesian algorithm"
HOMEPAGE="http://sites.google.com/site/nextgengenomics/ingap
	http://sourceforge.net/projects/ingap/"
SRC_URI="http://sourceforge.net/projects/ingap/files/ingap/v"${PV}"/inGAP_"${MY_PV}".tgz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-java/jfreechart
	dev-java/swing-layout
	dev-java/jcommon
	dev-java/itext
	dev-java/bytecode
	dev-java/biojava
	dev-java/absolutelayout" # gnujaxp ?

src_install(){
	dobin inGAP.jar || die
	# dobin external/bin/{primer3_core, run_cpp, trf}
	mv manual.pdf inGAP_Manual.pdf || die
	dodoc inGAP_Manual.pdf || die
	insinto /usr/share/inGAP
	doins doc/manual.htm
	insinto /usr/share/inGAP/manual_files
	doins doc/manual_files/*.png
}
