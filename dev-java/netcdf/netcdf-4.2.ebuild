# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Common Data Model (CDM) interface to to netCDF files"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf-java/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/${PN}-java/v${PV}/ncSrc-${PV}.zip"

LICENSE="netCDF"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/commons-codec:0
	dev-java/commons-httpclient:3
	dev-java/commons-logging:0
	dev-java/ehcache:1.2
	dev-java/jcommon:1.0
	dev-java/jdom:0
	dev-java/jfreechart:1.0
	dev-java/jgoodies-forms:0
	dev-java/joda-time:0
	dev-java/junit:4
	dev-java/log4j:0
	dev-java/slf4j-api:0
	dev-java/protobuf-java:0
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit4
		dev-java/hamcrest-core
	)"
BDEPEND="app-arch/unzip"

# There is a from-source maven package in java-overlay, but it hasn't
# been merged into the Portage trunk yet.

S="${WORKDIR}"

src_prepare() {
	default
	java-pkg_jar-from --into lib/external commons-codec commons-codec.jar
	java-pkg_jar-from --into lib/external commons-httpclient-3  commons-httpclient.jar
	java-pkg_jar-from --into lib/external commons-logging commons-logging.jar
	java-pkg_jar-from --into lib/external ehcache-1.2 ehcache.jar
	java-pkg_jar-from --into lib/external jcommon-1.0 jcommon.jar
	rm -f lib/external/jdom.jar || die
	java-pkg_jar-from --into lib/external jdom jdom.jar
	java-pkg_jar-from --into lib/external jfreechart-1.0 jfreechart.jar
	java-pkg_jar-from --into lib/external jgoodies-forms forms.jar jgoodies-forms.jar
	java-pkg_jar-from --into lib/external joda-time joda-time.jar
	java-pkg_jar-from --into lib/external junit-4 junit.jar
	java-pkg_jar-from --into lib/external log4j log4j.jar
	java-pkg_jar-from --into lib/external protobuf-java protobuf.jar
	java-pkg_jar-from --into lib/external slf4j-api slf4j-api.jar
}

src_compile() {
	cd "${S}"/cdm && eant
	use doc && eant javadoc
}

src_install() {
	java-pkg_newjar cdm/target/${P}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc cdm/target/javadoc
	use source && java-pkg_dosrc cdm/src/main/java/*
	use examples && java-pkg_doexamples cdm/src/test/java/examples
}
