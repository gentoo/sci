# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Tools for finite state automata construction and morphological dictionaries"
HOMEPAGE="https://github.com/morfologik/morfologik-stemming"
SRC_URI="https://github.com/morfologik/morfologik-stemming/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

CDEPEND="
	dev-java/jcommander:0
	dev-java/hppc:0
"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8"

S="${WORKDIR}/${PN}-stemming-${PV}"

JAVA_GENTOO_CLASSPATH="
	jcommander
	hppc
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
