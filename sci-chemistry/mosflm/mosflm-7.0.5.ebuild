# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fortran toolchain-funcs versionator eutils

MY_PV="$(delete_all_version_separators)"
MY_P="${PN}${MY_PV}"

FORTRAN="g77 gfortran ifc"

DESCRIPTION="A program for integrating single crystal diffraction data from area detectors"
HOMEPAGE="http://www.mrc-lmb.cam.ac.uk/harry/mosflm/"
SRC_URI="${HOMEPAGE}ver${MY_PV}/build-it-yourself/${MY_P}.tgz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/ccp4-libs"
DEPEND="${RDEPEND}
	x11-libs/libxdl_view
	app-shells/tcsh
	media-libs/jpeg"
# Needs older version as current, perhaps we can fix that next release
#	sci-libs/cbflib

S="${WORKDIR}/${MY_P}"

src_prepare() {
	rm src/dps/peak_search/dps_peaksearch
# See DEPEND
#	sed -e "s:../cbf/lib/libcbf.a:/usr/$(get_libdir)/libcbf.a:g" \
	sed -e "s:../jpg/libjpeg.a:/usr/$(get_libdir)/libjpeg.a:g" \
		-i ${PN}/Makefile || die

	epatch \
		"${FILESDIR}/${PV}"-Makefile.patch \
		"${FILESDIR}/${PV}"-parallel.patch
}

src_compile() {
	emake \
		MOSHOME=`pwd` \
		DPS=`pwd` \
		FC=${FORTRANC} \
		FLINK=${FORTRANC} \
		CC=$(tc-getCC) \
		AR_FLAGS=vru \
		MOSLIBS='-lccp4f -lccp4c -lxdl_view -lcurses -lXt -lmmdb -lccif -lstdc++' \
		MCFLAGS="-O0 -fno-second-underscore" \
		MOSFLAGS="${FFLAGS} -fno-second-underscore" \
		FFLAGS="${FFLAGS:- -O2}" \
		CFLAGS="${CFLAGS}" \
		MOSCFLAGS="${CFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin bin/ipmosflm || die
}
