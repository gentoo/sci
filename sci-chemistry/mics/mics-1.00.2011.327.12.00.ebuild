# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-opt-2

DESCRIPTION="Prediction of Protein Structural Motifs from NMR Chemical Shifts"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/MICS/"
SRC_URI="http://spin.niddk.nih.gov/bax/software/MICS/mics.tar.Z -> ${P}.tgz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND=">=virtual/jre-1.5:*"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/MICS

QA_PREBUILT="/opt/.*"

src_prepare() {
	rm -f bin/MICS.{mac,static.*,exe} || die
}

src_install() {
	local MICS="/opt/${PN}"
	exeinto /opt/bin
	newexe bin/MICS* ${PN}

	insinto ${MICS}
	doins -r tab

	java-pkg_jarinto ${MICS}
	java-pkg_dojar bin/rama.jar

	java-pkg_dolauncher jrama+ --jar rama.jar -into /opt/

	if use examples; then
		insinto /usr/share/${PN}
		doins -r demo
	fi

	cat >> "${T}"/40MICS <<- EOF
	MICS_DIR="${EPREFIX}/${MICS}"
	EOF
	doenvd "${T}"/40MICS
}
