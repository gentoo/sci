# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A multidimensional, type-agnostic image processing library."
HOMEPAGE="
	http://imglib2.net/
	https://github.com/imglib/imglib2
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/imglib/imglib2.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="net.imglib2:imglib2:9999"
else
	SRC_URI="
		https://github.com/imglib/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	MAVEN_ID="net.imglib2:imglib2:6.2.0"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

# jmh-core: According to the pom version 1.36 is required,
# however, jmh-core-1.35 is latest available in Gentoo
BDEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=sci-libs/jama-1.0.3
		>=dev-java/junit-4.13.2
		>=dev-java/jmh-core-1.35
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS=""

JAVA_TEST_GENTOO_CLASSPATH="jama,junit-4,jmh-core"
JAVA_TEST_SRC_DIR="src/test/java"
