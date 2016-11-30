# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool"
HOMEPAGE="http://compbio.charite.de/contao/index.php/jannovar.html"
SRC_URI="https://github.com/charite/jannovar/archive/v0.16.tar.gz -> ${P}.tar.gz"

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
	java-pkg_dojar jannovar-cli/target/jannovar-cli-0.16.jar
	java-pkg_dolauncher jannovar-cli --jar jannovar-cli-0.16.jar
	java-pkg_dojar jped-cli/target/jped-cli-0.16.jar
	java-pkg_dolauncher jped-cli --jar jped-cli-0.16.jar
	#java-pkg_dojar jannovar-hgvs/target/jannovar-hgvs-0.16.jar
	#java-pkg_dolauncher jannovar-hgvs --jar jannovar-hgvs-0.16.jar
	#java-pkg_dojar jannovar-htsjdk/target/jannovar-htsjdk-0.16.jar
	#java-pkg_dolauncher jannovar-htsjdk --jar jannovar-htsjdk-0.16.jar
	#java-pkg_dojar jannovar-core/target/jannovar-core-0.16.jar
	#java-pkg_dolauncher jannovar-core --jar jannovar-core-0.16.jar
	#java-pkg_dojar jannovar-filter/target/jannovar-filter-0.16.jar
	#java-pkg_dolauncher jannovar-filter --jar jannovar-filter-0.16.jar
	#java-pkg_dojar jannovar-inheritance-checker/target/jannovar-inheritance-checker-0.16.jar
	#java-pkg_dolauncher jannovar-inheritance-checker --jar jannovar-inheritance-checker-0.16.jar
}
