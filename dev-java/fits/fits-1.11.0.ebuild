# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
JAVA_PKG_IUSE="doc source test"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java library for FITS input/output"
HOMEPAGE="http://fits.gsfc.nasa.gov/fits_libraries.html#java_tam"
SRC_URI="http://heasarc.gsfc.nasa.gov/docs/heasarc/${PN}/java/v1.0/v${PV}/${PN}_src.jar -> ${P}-src.jar"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="dev-java/junit:4"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/ant-junit4
		dev-java/hamcrest-core
	)
	${CDEPEND}"

EANT_EXTRA_ARGS="-Dpacakge.version=${PV}"
EANT_GENTOO_CLASSPATH="junit-4"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_unpack() {
	mkdir -p ${P}/src && cd ${P}/src
	unpack ${A}
}

java_prepare() {
	cd "${S}"
	cp "${FILESDIR}"/README.Gentoo "${FILESDIR}"/build.xml . || die
	epatch \
		"${FILESDIR}"/01-Use-getResource-to-access-CompressTest-data-for-unit.patch \
		"${FILESDIR}"/02-Update-ArrayFuncsTest.java-to-JUnit-4.patch
}

src_test() {
	ANT_TASKS="ant-junit4" eant test
}

src_install() {
	java-pkg_newjar build/${PN}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
	#use examples && java-pkg_doexamples src/java/examples
}
