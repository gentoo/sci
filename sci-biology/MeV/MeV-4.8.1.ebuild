# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

#MY_PV="${PV/./_/}"
MY_PV="4_8_1"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Multiple experiment Viewer for genomic data analysis"
HOMEPAGE="http://mev-tm4.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/mev-tm4/mev-tm4/MeV%20${PV}/MeV_${MY_PV}_r2727_linux.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.5:*
	${DEPEND}"
DEPEND="${RDEPEND}
		>=virtual/jdk-1.5:*
		dev-java/ant-core
		"

S="${WORKDIR}"/"${PN}"_"${MY_PV}"
