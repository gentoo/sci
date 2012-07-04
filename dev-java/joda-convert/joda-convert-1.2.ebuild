# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library for conversion between Object and String"
HOMEPAGE="http://joda-convert.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-dist.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	dev-java/junit:4
	test? (
		dev-java/ant-junit4
		dev-java/hamcrest-core
	)"
RDEPEND=">=virtual/jre-1.5"

JAVA_PKG_WANT_SOURCE="5"
EANT_EXTRA_ARGS="-Dpacakge.version=${PV}"
EANT_GENTOO_CLASSPATH="junit-4"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_prepare() {
	cp "${FILESDIR}"/${PV}-build.xml build.xml
}

src_test() {
	ANT_TASKS="ant-junit4" eant test
}

src_install() {
	java-pkg_newjar build/${PN}.jar ${PN}.jar
	dodoc NOTICE.txt RELEASE-NOTES.txt
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/main/java/*
}
