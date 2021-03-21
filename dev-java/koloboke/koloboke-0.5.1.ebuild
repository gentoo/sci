# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Collections till the last breadcrumb of memory and performance"
HOMEPAGE="https://github.com/leventov/Koloboke"
SRC_URI="https://github.com/leventov/Koloboke/archive/refs/tags/compile-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=""

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8"

BDEPEND="test? (
	dev-java/hamcrest-core:1.3
)"

S="${WORKDIR}/${PN^}-compile-${PV}"

JAVA_TEST_GENTOO_CLASSPATH="
	hamcrest-core
"

src_prepare() {
	# we need an additional unavailable dep for the tests
	find . -type d -name "test" -exec rm -rf {} + || die
	default
}

src_install() {
	einstalldocs
	java-pkg_dojar ${PN}.jar
}
