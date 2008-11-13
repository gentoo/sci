# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran toolchain-funcs versionator

MY_PV="$(delete_all_version_separators)"
MY_P="${PN}${MY_PV}"
DESCRIPTION="A program for integrating single crystal diffraction data from area detectors"
HOMEPAGE="http://www.mrc-lmb.cam.ac.uk/harry/mosflm/"
SRC_URI="${HOMEPAGE}ver${MY_PV}/build-it-yourself/${MY_P}.tgz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="sci-chemistry/ccp4"
DEPEND="${RDEPEND}
	app-shells/tcsh"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	F77=$(tc-getF77)

	emake \
		-j1 \
		MOSHOME=`pwd` \
		DPS=`pwd` \
		FC=$(tc-getFC) \
		FLINK=$(tc-getFC) \
		AR_FLAGS=vru \
		MOSLIBS='-lccp4f -lccp4c -lxdl_view -lcurses -lXt -lmmdb -lccif -lstdc++' \
		MCFLAGS="${FFLAGS} -fno-second-underscore" \
		MOSFLAGS="${FFLAGS} -fno-second-underscore" \
		CC=$(tc-getCC) \
		FFLAGS="${FFLAGS:- -O2}" \
		CFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin bin/ipmosflm || die
}
