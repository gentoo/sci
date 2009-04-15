# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-commons-logging"

inherit eutils java-pkg-2 java-ant-2 multilib

DESCRIPTION="Java docking framework for use in cross-platform Swing applications"
HOMEPAGE="https://flexdock.dev.java.net/"
SRC_URI="https://flexdock.dev.java.net/files/documents/2037/52480/${P}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-java/jgoodies-looks:2.0
	dev-java/commons-logging
	dev-java/skinlf
	dev-java/jmf-bin
	=virtual/jdk-1.6*"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ali_bush.patch
	sed -e "s:/usr/X11R6/lib:/usr/$(get_libdir):g" \
		-e "s:jmf/lib/jmf.jar:jmf.jar:g" \
		-e "s:/usr/X11R6/include:/usr/include:g" \
		-e "s~c:/jdk1.5.0._03~${JAVA_HOME}~g" \
		-i build.xml
	java-pkg-2_src_prepare
}

src_compile() {
	ANT_OPTS="${ANT_OPTS} -Xmx256m"

	cd "${S}"/lib

	java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar
	java-pkg_jar-from skinlf
	java-pkg_jar-from jmf-bin
	java-pkg_jar-from jgoodies-looks-2.0 looks.jar looks-2.1.1.jar

	cd "${S}"

	eant compile.native dist
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	java-pkg_newjar build/${PN}-demo-${PV}.jar ${PN}-demo.jar
	dodoc docs/*.{doc,pdf,txt} || die "no docs"

	use doc && java-pkg_dojavadoc build/docs/api/
}
