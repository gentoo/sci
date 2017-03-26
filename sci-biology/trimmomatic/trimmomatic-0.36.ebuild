# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2

DESCRIPTION="Illumina adapter trimming tool"
HOMEPAGE="http://www.usadellab.org/cms/?page=trimmomatic"
SRC_URI="
	http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-Src-${PV}.zip
	http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf -> "${P}"_manual.pdf"

# http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.32.zip

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.6:*
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.6:*"

# somehow fails to build with oracle-jdk-bin-1.7 while ibm-jdk-bin-1.6 works

EANT_BUILD_TARGET="dist"

src_install() {
	java-pkg_newjar "dist/jar/${P}.jar" "${PN}.jar"
	insinto /usr/share/${PN}/Illumina
	doins adapters/*.fa
	insinto /usr/share/doc/${P}
	dodoc "${DISTDIR}"/${P}_manual.pdf
}
