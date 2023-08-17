# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java bindings for various FreeDesktop.org standards"
HOMEPAGE="https://github.com/kothar/xdg-java"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kothar/xdg-java.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="net.kothar:xdg-java:9999"
else
	SRC_URI="
		https://github.com/kothar/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}-sources.tar.gz
		"
	S="${WORKDIR}/${P}"
	MAVEN_ID="net.kothar:xdg-java:0.1.1"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND=">=virtual/jdk-1.8:*"

BDEPEND="
	>=virtual/jdk-1.8:*
	test? (
	      >=dev-java/junit-4.13.2:4
	      )
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
