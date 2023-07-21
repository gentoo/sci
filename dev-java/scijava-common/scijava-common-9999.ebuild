# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SciJava Common is a shared library for SciJava software."
HOMEPAGE="
	https://imagej.net/libs/scijava#scijava-common
	https://github.com/scijava/scijava-common
	"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scijava/scijava-common.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="org.scijava:scijava-common:9999"
else
	SRC_URI="
		https://github.com/scijava/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	MAVEN_ID="org.scijava:scijava-common:2.94.2"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

CDEPEND="
	dev-java/parsington:0
	dev-java/jaxws-api:0
	dev-java/jaxb-api:2
"

BDEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		>=dev-java/junit-4.13.2
		>=dev-java/mockito-2.19.0
	)
"

DEPEND="${CDEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

JAVA_GENTOO_CLASSPATH="parsington,jaxws-api,jaxb-api-2"
JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS=""
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-2"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)
