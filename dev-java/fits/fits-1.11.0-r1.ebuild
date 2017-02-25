# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library for FITS input/output"
HOMEPAGE="http://fits.gsfc.nasa.gov/fits_libraries.html#java_tam"
SRC_URI="http://heasarc.gsfc.nasa.gov/docs/heasarc/${PN}/java/v1.0/v${PV}/${PN}_src.jar -> ${P}-src.jar"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="dev-java/junit:4"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	test? ( dev-java/ant-junit4:0 )"

EANT_EXTRA_ARGS="-Dpackage.version=${PV}"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="junit-4"

src_unpack() {
	mkdir -p ${P}/src && cd ${P}/src || die
	unpack ${A}
}

java_prepare() {
	cd "${S}" || die
	cp "${FILESDIR}"/README.Gentoo "${FILESDIR}"/build.xml . || die
	epatch \
		"${FILESDIR}"/01-Use-getResource-to-access-CompressTest-data-for-unit.patch \
		"${FILESDIR}"/02-Update-ArrayFuncsTest.java-to-JUnit-4.patch

	if ! use test; then
		find "${S}" \( -name "*Test.java" -o -name "*Tester.java" \) -print -delete || die
	fi

	# from http://heasarc.gsfc.nasa.gov/docs/heasarc/fits/java/v1.0/NOTE.v111.0:
	# The source code JAR (fits_src.jar) includes a number of new classes for
	# which the corresponding class files are not included in fits.jar.  These
	# classes are pre-alpha versions of support for tile compressed data that
	# is being developed.  Interested Users may take a look at these, but they
	# definitely are not expected to work today.
	rm 	src/nom/tam/image/comp/Quantizer.java \
		src/nom/tam/image/comp/RealStats.java \
		src/nom/tam/image/comp/TiledImageHDU.java \
		src/nom/tam/image/QuantizeRandoms.java \
		src/nom/tam/image/TileDescriptor.java \
		src/nom/tam/image/TileLooper.java || die
}

src_test() {
	ANT_TASKS="ant-junit4" java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
