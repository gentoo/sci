# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="Manipulate and analyze VCF files"
HOMEPAGE="https://github.com/RealTimeGenomics/rtg-tools"
SRC_URI="https://github.com/RealTimeGenomics/rtg-tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
	>=dev-java/ant-core-1.9
	dev-java/jython"
RDEPEND="${DEPEND}
	>=virtual/jre-1.8:*"

src_compile(){
	ant zip-nojre || die
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

src_install(){
	dobin installer/rtg
	insinto /usr/share/"${PN}"
	doins build/rtg-tools.jar
	doins lib/gzipfix.jar
	dodoc installer/resources/tools/RTGOperationsManual.pdf
	doins -r installer/resources/tools/RTGOperationsManual
	dodoc installer/resources/tools/scripts/README.txt
	dodoc installer/ReleaseNotes.txt
	# TODO
	# extract more files from the generated rtg-tools-3.11-39691f9f-base.zip
	# file or better the installer/resources/ source directory
	#
	# install installer/resources/common/scripts/rtg-bash-completion
}

src_test(){
	ant runalltests || die
}
