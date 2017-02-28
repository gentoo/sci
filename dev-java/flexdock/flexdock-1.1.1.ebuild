# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Java docking framework for use in cross-platform Swing applications"
HOMEPAGE="http://flexdock.dev.java.net/"
SRC_URI="http://forge.scilab.org/index.php/p/flexdock/downloads/get/${P}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND="
	app-arch/unzip
	dev-java/skinlf
	dev-java/jgoodies-looks:2.0
	>=virtual/jdk-1.4"

EANT_DOC_TARGET="doc"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${P}-nodemo.patch )

src_prepare() {
	eapply ${PATCHES[@]}
	java-pkg-2_src_prepare
	#some cleanups
	find . -type f -name '*.so' -exec rm -v {} \;|| die
	find . -type f -name '*.dll' -exec rm -v {} \;|| die

	#remove built-in jars and use the system ones
	cd lib || die
	rm -rvf *.jar jmf|| die
	java-pkg_jar-from skinlf
	java-pkg_jar-from jgoodies-looks-2.0 looks.jar
}

src_install() {
	java-pkg_newjar "build/${P}.jar" "${PN}.jar"
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src
}
