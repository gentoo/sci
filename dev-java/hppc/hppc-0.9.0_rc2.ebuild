# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-pkg-simple

MY_PV="${PV//_/.}"

DESCRIPTION="High Performance Primitive Collections for Java"
HOMEPAGE="https://github.com/carrotsearch/hppc"
SRC_URI="https://github.com/carrotsearch/hppc/archive/refs/tags/${MY_PV^^}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

CDEPEND="
	dev-java/antlr:4
	dev-java/fastutil:0
	dev-java/jcommander:0
	dev-java/jmh-core:0
	dev-java/velocity:0
	dev-java/slf4j-simple:0
"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8"

S="${WORKDIR}/${PN}-${MY_PV^^}"

JAVA_GENTOO_CLASSPATH="
	antlr:4
	fastutil
	jcommander
	jmh-core
	velocity
	slf4j-simple
"

src_prepare() {
	# we need an additional unavailable dep for the tests
	rm -r */src/test || die
	default
}

src_install() {
	einstalldocs
	java-pkg_dojar ${PN}.jar
}
