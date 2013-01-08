# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provides a common base for graphical component to build a graphical console."
HOMEPAGE="http://dev.artenum.com/projects/jrosetta"
SRC_URI="http://maven.artenum.com/content/groups/public/com/artenum/${PN}/${PV}/${P}-sources.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"

RDEPEND=">=virtual/jre-1.5"

EANT_BUILD_TARGET="compile package"
JAVA_ANT_BSFIX_EXTRA_ARGS="--maven-cleaning"

java_prepare () {
	cp "${FILESDIR}/api-build.xml" modules/jrosetta-api/build.xml || die
	cp "${FILESDIR}/engine-build.xml" modules/jrosetta-engine/build.xml || die
	cp "${FILESDIR}/build.xml" . || die
	echo "${PV}" > modules/jrosetta-engine/src/main/resources/version.txt || die
}

src_install () {
	java-pkg_newjar "modules/jrosetta-api/target/jrosetta-api-${PV}.jar" \
	jrosetta-api.jar
	java-pkg_newjar "modules/jrosetta-engine/target/jrosetta-engine-${PV}.jar" \
	jrosetta-engine.jar
}
