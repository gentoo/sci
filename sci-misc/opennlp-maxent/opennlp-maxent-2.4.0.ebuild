# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="source examples doc"

inherit eutils java-pkg-2 java-ant-2

MY_PN="maxent"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Maximum entropy model implementation for opennlp"
HOMEPAGE="http://maxent.sf.net/"
SRC_URI="mirror://sourceforge/maxent/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="${IUSE}"

COMMON_DEP="
	dev-java/java-getopt
	dev-java/trove:0"
DEPEND=">=virtual/jdk-1.4:*
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4:*
	${COMMON_DEP}"

EANT_BUILD_TARGET="compile package"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	cd "${S}"/lib || die
	rm -v *.jar || die "failed to rm jars"
	java-pkg_jarfrom java-getopt-1 gnu.getopt.jar java-getopt.jar
	java-pkg_jarfrom trove
}

src_install() {
	java-pkg_newjar output/${MY_P}.jar
	java-pkg_dohtml docs/*html docs/*css docs/*jpg
	if use doc ; then
		java-pkg_dojavadoc docs/api
	fi
	if use source ; then
		java-pkg_dosrc src/java/opennlp
	fi
	if use examples ; then
		java-pkg_doexamples samples
	fi
	dodoc AUTHORS CHANGES COMMANDLINE README
	# java-pkg_dolauncher
}
