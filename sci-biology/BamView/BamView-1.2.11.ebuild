# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Display read alignments in BAM files, is a part of Artemis"
HOMEPAGE="http://bamview.sourceforge.net/"
SRC_URI="http://bamview.sourceforge.net/v"${PV}"/BamView_v"${PV}".jar"

#http://www.ncbi.nlm.nih.gov/pubmed/20071372
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.6:*
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.6:*"
