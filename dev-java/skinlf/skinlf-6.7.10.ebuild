# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Skin Look and Feel - Skinning Engine for the Swing toolkit"
HOMEPAGE="http://skinlf.l2fprod.com/"
# Upstream is gone, use this url from ubuntu/debian instead
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libskinlf-java/$(ver_rs 2 -)/libskinlf-java_$(ver_cut 1-2).orig.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/laf-plugin:0
	dev-java/xalan:0"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-image-utils-without-jimi.patch"
)

S="${WORKDIR}/${PN}-$(ver_cut 1-2)"

src_prepare() {
	default

	cp "${FILESDIR}/${P}-build.xml" build.xml || die
	cp "${FILESDIR}/${P}-common.xml" common.xml || die

	cd lib || die

	java-pkg_jar-from xalan,laf-plugin
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	# laf-plugin.jar is referenced in manifest's Class-Path
	# doesn't work without it due to class loader trickery
	# upstream solved this by absorbing laf-plugin in own jar...
	java-pkg_dojar lib/laf-plugin.jar

	use examples && java-pkg_doexamples src/examples
	use source && java-pkg_dosrc src/com src/*.java

	dodoc CHANGES README
}
