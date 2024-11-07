# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Illumina adapter trimming tool"
HOMEPAGE="http://www.usadellab.org/cms/?page=trimmomatic"
SRC_URI="
	http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-Src-${PV}.zip
	http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf -> "${P}"_manual.pdf"

# http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.32.zip

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.7:*
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.7:*"

src_prepare() {
	sed -i -E 's/source="[0-9\.]+"//g' build.xml || die
	sed -i -E 's/target="[0-9\.]+"//g' build.xml || die
	default
}

src_compile() {
	eant dist \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)"
}

src_install() {
	java-pkg_newjar "dist/jar/${P}.jar" "${PN}.jar"
	insinto /usr/share/${PN}/Illumina
	doins adapters/*.fa
	dodoc "${DISTDIR}"/${P}_manual.pdf
}
