# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2

MYP="Healpix_${PV}"
MYPP="2013Apr24"

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere - Java"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}/${MYP}_${MYPP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc test"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit:4 )"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MYP}/src/java"

EANT_BUILD_TARGET="distonly distsrc newcompile"
EANT_DOC_TARGET="docs newdocs"

src_test() {
	EANT_TEST_TARGET="test newtest"
	EANT_TEST_GENTOO_CLASSPATH="junit-4"
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar dist/*.jar
	dodoc README CHANGES SuggestedIdeas.txt
	dodoc ../../READ_Copyrights_Licenses.txt
	use doc && java-pkg_dojavadoc healpixdoc
}
