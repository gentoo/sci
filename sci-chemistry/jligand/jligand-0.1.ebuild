# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit java-pkg-2 java-ant-2 multilib

MY_PN="JLigand"

DESCRIPTION="a Java interface which allows links descriptions to be created"
HOMEPAGE="http://www.ysbl.york.ac.uk/~pyoung/JLigand/JLigand.html"
SRC_URI="http://www.ysbl.york.ac.uk/~pyoung/${MY_PN}/${MY_PN}_${PV}_Source.tar"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	sci-chemistry/refmac
	sci-libs/monomer-db"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}"/${MY_PN}

EANT_EXTRA_ARGS="-Dfile.encoding=ISO-8859-1"

src_install() {
	java-pkg_dojar dist/${MY_PN}.jar
	java-pkg_dolauncher ${PN} \
		--main uk.ac.york.ysbl.JLigand \
		--jar ${MY_PN}.jar \
		--pkg_args "/usr/$(get_libdir)/${PN} ${CLIBD_MON} /usr/bin/libcheck /usr/bin/refmac"

	insinto /usr/$(get_libdir)/${PN}
	doins -r src/{images,resources} || die
	fperms 775 /usr/$(get_libdir)/${PN}/resources/runLibcheck.csh || die
	fperms 775 /usr/$(get_libdir)/${PN}/resources/runRefmac.csh || die
}

