# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Genotype calling/phasing, imputation of ungenotyped markers"
HOMEPAGE="https://faculty.washington.edu/browning/beagle/beagle.html"
SRC_URI="
	https://faculty.washington.edu/browning/beagle/beagle.18May20.d20.jar
	https://faculty.washington.edu/browning/beagle/beagle_${PV}_08Nov19.pdf
	https://faculty.washington.edu/browning/beagle/run.beagle.18May20.d20.example -> ${PN}-example.sh
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND="${DEPEND}
	sci-biology/conform-gt"

S="${WORKDIR}"

src_install() {
	java-pkg_newjar "${DISTDIR}/beagle.18May20.d20.jar" "${PN}.jar"
	dodoc "${DISTDIR}/beagle_${PV}_08Nov19.pdf"
	dodoc "${DISTDIR}/${PN}-example.sh"
}
