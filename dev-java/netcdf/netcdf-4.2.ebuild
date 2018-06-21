# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source test"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java Common Data Model (CDM) interface to to netCDF files"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf-java/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/${PN}-java/v${PV}/ncSrc-${PV}.zip"

LICENSE="netCDF"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-java/commons-codec
	dev-java/commons-httpclient
	dev-java/commons-logging
	dev-java/ehcache:*
	dev-java/jcommon
	dev-java/jdom:*
	dev-java/jfreechart
	dev-java/jgoodies-forms:*
	dev-java/joda-time
	dev-java/log4j
	dev-java/slf4j-api
	dev-java/protobuf-java"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit4
		dev-java/hamcrest-core
	)"

# There is a from-source maven package in java-overlay, but it hasn't
# been merged into the Portage trunk yet.

S="${WORKDIR}"

src_prepare() {
	java-pkg_jar-from --into lib/external commons-codec commons-codec.jar
	java-pkg_jar-from --into lib/external commons-httpclient-3  commons-httpclient.jar
	java-pkg_jar-from --into lib/external commons-logging commons-logging.jar
	java-pkg_jar-from --into lib/external ehcache-1.2 ehcache.jar
	java-pkg_jar-from --into lib/external jcommon-1.0 jcommon.jar
	rm -f lib/external/jdom.jar || die
	java-pkg_jar-from --into lib/external jdom-1.0 jdom.jar
	java-pkg_jar-from --into lib/external jfreechart-1.0 jfreechart.jar
	java-pkg_jar-from --into lib/external jgoodies-forms forms.jar jgoodies-forms.jar
	java-pkg_jar-from --into lib/external joda-time joda-time.jar
	java-pkg_jar-from --into lib/external junit-4 junit.jar
	java-pkg_jar-from --into lib/external log4j log4j.jar
	java-pkg_jar-from --into lib/external protobuf protobuf.jar
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
