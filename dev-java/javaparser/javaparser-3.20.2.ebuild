# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java 1-15 Parser and Abstract Syntax Tree for Java."
HOMEPAGE="https://github.com/javaparser/javaparser"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PN}-parent-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="0"
KEYWORDS=""

CDEPEND="
	dev-java/javassist:3
"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8"

S="${WORKDIR}/${PN}-${PN}-parent-${PV}"

JAVA_GENTOO_CLASSPATH="
	javassist-3
"

JAVA_SRC_DIR=(
	"${PN}-core"
	"${PN}-symbol-solver-core"
	"${PN}-core-serialization"
	"${PN}-core-metamodel-generator"
	"${PN}-core-generators"
)

# src_prepare() {
# 	# we need an additional unavailable dep for the tests
# 	rm -r */src/test || die
# 	default
# }

src_install() {
	einstalldocs
	java-pkg_dojar ${PN}.jar
}
