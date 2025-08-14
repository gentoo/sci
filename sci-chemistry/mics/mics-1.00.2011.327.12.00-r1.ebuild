# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-opt-2

DESCRIPTION="Prediction of Protein Structural Motifs from NMR Chemical Shifts"
HOMEPAGE="https://spin.niddk.nih.gov/bax/software/MICS/"

SRC_URI="https://spin.niddk.nih.gov/bax/software/MICS/mics.tar.Z -> ${P}.tgz"
S="${WORKDIR}/${PN^^}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="examples"

RESTRICT="test"

DEPEND=">=virtual/jdk-1.5:*"
RDEPEND=">=virtual/jre-1.5:*"

QA_PREBUILT="/opt/.*"

src_prepare() {
	default

	rm bin/MICS.{mac,static.*,exe} || die
}

src_install() {
	local MICS="/opt/${PN}"

	exeinto /opt/bin
	newexe bin/MICS* "${PN}"

	insinto "${MICS}"
	doins -r tab

	java-pkg_jarinto "${MICS}"
	java-pkg_dojar bin/rama.jar

	java-pkg_dolauncher jrama+ --jar rama.jar -into /opt/

	if use examples; then
		insinto "/usr/share/${PN}"
		doins -r demo
	fi

	newenvd - "${T}/40MICS" <<- EOF
		MICS_DIR="${EPREFIX}/${MICS}"
	EOF
}
