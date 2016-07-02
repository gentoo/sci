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
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

src_install(){
	java-pkg_newjar "${DISTDIR}"/jannovar-cli-"${PV}".jar jannovar-cli.jar
	java-pkg_dolauncher jannovar-cli-bin --jar jannovar-cli.jar
	java-pkg_newjar "${DISTDIR}"/jped-cli-"${PV}".jar jped-cli.jar
	java-pkg_dolauncher jped-cli-bin --jar jped-cli.jar
}
