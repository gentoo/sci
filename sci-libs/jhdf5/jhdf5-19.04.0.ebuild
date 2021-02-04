# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java binding for HDF5 compatible with HDF5 1.6/1.8"
HOMEPAGE="https://wiki-bsse.ethz.ch/display/JHDF5"
SRC_URI="https://wiki-bsse.ethz.ch/download/attachments/26609237/sis-jhdf5-${PV}.zip"
# first SIS release: https://wiki-bsse.ethz.ch/download/attachments/26609237/sis-jhdf5-14.12.0-r33145.zip
# last CISD release: https://wiki-bsse.ethz.ch/download/attachments/26609237/cisd-jhdf5-13.06.2-r29633.zip

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.7:*
	app-arch/unzip
	dev-java/args4j:*
	dev-java/commons-io:*
	dev-java/commons-lang:*
"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}/sis-jhdf5"

src_install() {
	dobin bin/h5ar
	java-pkg_newjar lib/sis-${P}.jar sis-${PN}.jar
	java-pkg_dolauncher sis-${PN} --jar sis-${PN}.jar
	java-pkg_newjar lib/sis-${PN}-h5ar-cli-${PV}.jar sis-${PN}-h5ar-cli.jar
	java-pkg_dolauncher sis-${PN}-h5ar-cli --jar sis-${PN}-h5ar-cli.jar
	dodoc doc/JHDF5-${PV}.*
}
