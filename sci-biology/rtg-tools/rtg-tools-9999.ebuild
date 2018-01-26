# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 eutils git-r3

DESCRIPTION="Manipulate and analyze VCF files"
HOMEPAGE="https://github.com/RealTimeGenomics/rtg-tools"
EGIT_REPO_URI="https://github.com/RealTimeGenomics/rtg-tools.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
		>=virtual/jdk-1.8:*
		dev-java/ant-core
		dev-java/jython"
RDEPEND="${DEPEND}
		>=virtual/jre-1.8:*"

src_compile(){
	ant runalltests || die
}

# "${S}"/lib/sam-2.9.1.jar
# "${S}"/lib/findbugs-annotations.jar
# "${S}"/lib/findbugs-jsr305.jar
# "${S}"/lib/velocity-tools-generic.jar
# "${S}"/lib/RPlot.jar
# "${S}"/lib/commons-collections-3.2.1.jar
# "${S}"/lib/velocity-1.7.jar
# "${S}"/lib/commons-compress-1.4.1.jar
# "${S}"/lib/commons-lang-2.4.jar
# "${S}"/lib/jumble-annotations.jar
# "${S}"/lib/sam-2.9.1-src.jar
# "${S}"/lib/gzipfix.jar
# "${S}"/buildLib/ant-contrib-1.0b3.jar
# "${S}"/buildLib/handlechecker.jar
# "${S}"/testLib/hamcrest-core-1.3.jar
# "${S}"/testLib/junit.jar
# "${S}"/testLib/spelling.jar
