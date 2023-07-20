# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A mathematical expression parser for infix expression strings"
HOMEPAGE="https://github.com/scijava/parsington"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scijava/parsington.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="org.scijava:parsington:9999"
else
	SRC_URI="
		https://github.com/scijava/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	MAVEN_ID="org.scijava:parsington:3.1.0"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

CDEPEND=">=dev-java/junit-5.9.1:5"

BDEPEND="
	>=virtual/jdk-1.8:*
	test? (
	      "${CDEPEND}"
	)
"

DEPEND="${CDEPEND}"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS="org.scijava.parsington.Main"

JAVA_TEST_GENTOO_CLASSPATH="junit-5"
JAVA_TEST_SRC_DIR="src/test/java"
