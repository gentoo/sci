# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool"
HOMEPAGE="http://compbio.charite.de/contao/index.php/jannovar.html"
SRC_URI="https://github.com/charite/jannovar/archive/v"${PV}".tar.gz -> ${P}.tar.gz"

# https://github.com/charite/jannovar
LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPS="
	dev-java/commons-compress
	dev-java/commons-io
	dev-java/commons-jexl:*
	dev-java/commons-logging:0
	dev-java/commons-net
	dev-java/guava:*
	dev-java/hamcrest-core:*
	dev-java/htsjdk
	dev-java/ini4j
	dev-java/junit:*
	dev-java/log4j:0"
DEPEND=">=virtual/jdk-1.6
	dev-java/maven-bin:*
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPS}"

# TODO: set a proxy because it downloads data during compile step
# http://jannovar.readthedocs.io/en/master/install.html
# see https://github.com/charite/jannovar/issues/218
# https://maven.apache.org/settings.html#Proxies
src_compile(){
	mvn package -Dmaven.test.skip.exec=true -DskipTests=true -Duser.home="${HOME}" || die
}

src_install(){
	# maven download 95MB from the network into "${PORTAGE_BUILDDIR}/homedir/"
	export M2="${HOME}"
	mvn install -Dmaven.test.skip.exec=true -Duser.home="${HOME}" || die
	# jannovar-cli-${PV}.jar includes all libraries (jannovar and others like htsjdk)
	java-pkg_dojar jannovar-cli/target/jannovar-cli-"${PV}".jar
	java-pkg_dolauncher jannovar-cli --jar jannovar-cli-"${PV}".jar
	# original-jannovar-cli-0.17.jar contains only the source files of the specific package
	java-pkg_dojar jannovar-cli/target/original-jannovar-cli-"${PV}".jar
	java-pkg_dojar jannovar-hgvs/target/jannovar-hgvs-"${PV}".jar
	java-pkg_dojar jannovar-htsjdk/target/jannovar-htsjdk-"${PV}".jar
	java-pkg_dojar jannovar-core/target/jannovar-core-"${PV}".jar
	java-pkg_dojar jannovar-vardbs/target/jannovar-vardbs-"${PV}".jar
	java-pkg_dojar jannovar-inheritance-checker/target/jannovar-inheritance-checker-"${PV}".jar
}
