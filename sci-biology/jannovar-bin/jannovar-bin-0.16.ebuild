# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool"
HOMEPAGE="http://compbio.charite.de
	https://github.com/charite/jannovar"
SRC_URI="https://github.com/charite/jannovar/releases/download/v${PV}/jannovar-cli-${PV}.jar
	https://repo1.maven.org/maven2/de/charite/compbio/jped-cli/${PV}/jped-cli-${PV}.jar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

# BUG: the two jar file soverwrite each other somehow during install
src_install(){
	cp "${DISTDIR}"/jannovar-cli-"${PV}".jar jannovar-cli-bin.jar
	java-pkg_newjar jannovar-cli-bin.jar
	java-pkg_dolauncher jannovar-bin --jar jannovar-cli-"${PV}".jar
	cp "${DISTDIR}"/jped-cli-"${PV}".jar jped-cli-bin.jar
	java-pkg_newjar jped-cli-bin.jar
	java-pkg_dolauncher jped-cli-bin --jar jped-cli-"${PV}".jar
}
