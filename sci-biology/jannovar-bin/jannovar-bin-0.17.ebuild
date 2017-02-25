# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2

DESCRIPTION="Exome annotation tool (upstream jar binaries)"
HOMEPAGE="http://compbio.charite.de
	https://github.com/charite/jannovar"
SRC_URI="https://search.maven.org/remotecontent?filepath=de/charite/compbio/jannovar-cli/${PV}/jannovar-cli-${PV}.jar
	https://search.maven.org/remotecontent?filepath=de/charite/compbio/jannovar-vardbs/${PV}/jannovar-vardbs-${PV}.jar
	https://search.maven.org/remotecontent?filepath=de/charite/compbio/jannovar-htsjdk/${PV}/jannovar-htsjdk-${PV}.jar
	https://search.maven.org/remotecontent?filepath=de/charite/compbio/jannovar-inheritance-checker/${PV}/jannovar-inheritance-checker-${PV}.jar
	https://search.maven.org/remotecontent?filepath=de/charite/compbio/jannovar-core/${PV}/jannovar-core-${PV}.jar
	https://search.maven.org/remotecontent?filepath=de/charite/compbio/jannovar-hgvs/${PV}/jannovar-hgvs-${PV}.jar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

src_install(){
	java-pkg_newjar "${DISTDIR}"/jannovar-cli-"${PV}".jar jannovar-cli.jar
	java-pkg_dolauncher jannovar-cli-bin --jar jannovar-cli.jar
	java-pkg_newjar "${DISTDIR}"/jannovar-vardbs-"${PV}".jar jannovar-vardbs.jar
	java-pkg_newjar "${DISTDIR}"/jannovar-htsjdk-"${PV}".jar jannovar-htsjdk.jar
	java-pkg_newjar "${DISTDIR}"/jannovar-inheritance-checker-"${PV}".jar jannovar-inheritance-checker.jar
	java-pkg_newjar "${DISTDIR}"/jannovar-core-${PV}.jar jannovar-core.jar
	java-pkg_newjar "${DISTDIR}"/jannovar-hgvs-${PV}.jar jannovar-hgvs.jar
}
