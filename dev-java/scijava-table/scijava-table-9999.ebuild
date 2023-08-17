# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Table structures for SciJava."
HOMEPAGE="https://github.com/scijava/scijava-table"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scijava/scijava-table.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="org.scijava:scijava-table:9999"
else
	SRC_URI="
		https://github.com/scijava/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	MAVEN_ID="org.scijava:scijava-table:1.0.3"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

CDEPEND="
	>=dev-java/scijava-common-2.89.0:0
	>=dev-java/scijava-optional-1.0.1:0
"

BDEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? ( >=dev-java/junit-4.13.2:4 )
"

DEPEND="${CDEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

JAVA_GENTOO_CLASSPATH="scijava-common,scijava-optional"
JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS=""

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
