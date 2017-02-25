# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-opt-2

DESCRIPTION="Prediction of Protein bb and sc Torsion Angles from NMR Chemical Shifts"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/TALOS-N/"
SRC_URI="http://spin.niddk.nih.gov/bax/software/TALOS-N/talosn.tZ -> ${P}.tgz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

DEPEND=">=virtual/jre-1.5:*"
RDEPEND="${DEPEND}
	app-shells/tcsh
	sci-biology/ncbi-tools"

S="${WORKDIR}"

QA_PREBUILT="/opt/.*"

src_prepare() {
	local s64
	use amd64 || s64="_x64"
	rm -f bin/TALOSN.{linux,mac,static.*,winxp,linux9${s64}} || die

	sed \
		-e '/setenv TALOSN_DIR/d' \
		-e "/set BLAST/s:=.*:= \"${EPREFIX}/usr/bin/blastpgp\":g" \
		-e '/set NR_DBNAME/s:=.*:= ${BLASTDB}:g' \
		-i talosn_ss || die
}

src_install() {
	local TALOSN="/opt/${PN}"
	exeinto ${TALOSN}/bin
	doexe bin/*

	exeinto ${TALOSN}/com
	doexe com/*

	exeinto /opt/bin
	doexe talosn{,_ss}

	insinto ${TALOSN}
	doins -r tab

	java-pkg_jarinto ${TALOSN}
	java-pkg_dojar rama.jar

	java-pkg_dolauncher jrama --jar rama.jar -into /opt/

	if use examples; then
		insinto /usr/share/${PN}
		doins -r demo
	fi

	cat >> "${T}"/40talosn <<- EOF
	TALOSN_DIR="${EPREFIX}/${TALOSN}"
	#BLASTDB=
	EOF
	doenvd "${T}"/40talosn
}
