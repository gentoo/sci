# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Common base for graphical component to build a graphical console"
HOMEPAGE="http://dev.artenum.com/projects/jrosetta"
#currently down
#SRC_URI="http://maven.artenum.com/content/groups/public/com/artenum/${PN}/${PV}/${P}-sources.jar"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}/${P}-sources.jar/5c3589d4207f71bad6eeefd4857bce50/${P}-sources.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	>=virtual/jdk-1.5:*
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5:*"

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
