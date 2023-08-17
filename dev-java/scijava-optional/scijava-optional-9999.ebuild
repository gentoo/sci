# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Helpers for emulating named and default arguments"
HOMEPAGE="https://github.com/scijava/scijava-optional"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scijava/scijava-optional.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="org.scijava:scijava-optional:9999"
else
	SRC_URI="
		https://github.com/scijava/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	MAVEN_ID="org.scijava:scijava-optional:1.0.2"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

BDEPEND="
	>=virtual/jdk-1.8:*
	test? (
		 >=dev-java/junit-4.13.2:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS=""

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
