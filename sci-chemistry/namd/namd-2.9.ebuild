# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib toolchain-funcs flag-o-matic

DESCRIPTION="A powerful and highly parallelized molecular dynamics code"
LICENSE="namd"
HOMEPAGE="http://www.ks.uiuc.edu/Research/namd/"

MY_PN="NAMD"
MY_PV="2.9"

SRC_URI="${MY_PN}_${MY_PV}_Source.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="fetch"

DEPEND="
	app-shells/tcsh
	sys-cluster/charm[static-libs]
	sci-libs/fftw:2.1
	dev-lang/tcl"

RDEPEND=${DEPEND}

NAMD_ARCH="Linux-x86_64-g++"

NAMD_DOWNLOAD="http://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD"

S="${WORKDIR}/${MY_PN}_${MY_PV}_Source"

pkg_nofetch() {
	echo
	einfo "Please download ${MY_PN}_${MY_PV}_Source.tar.gz from"
	einfo "${NAMD_DOWNLOAD}"
	einfo "after agreeing to the license and then move it to"
	einfo "${DISTDIR}"
	einfo "Be sure to select the ${MY_PV} version!"
	echo
}

src_prepare() {
	CHARM_VERSION=$(best_version sys-cluster/charm | cut -d- -f3)

	# apply a few small fixes to make NAMD compile and
	# link to the proper libraries
	epatch "${FILESDIR}"/namd-2.9-gentoo.patch
	epatch "${FILESDIR}"/namd-2.7-iml-dec.patch
	sed \
		-e "s:charm-.\+:charm-${CHARM_VERSION}:" \
		-i Make.charm || die

	rm -f charm-6.4.0.tar || die

	# proper compiler and cflags
	sed \
		-e "s/g++/$(tc-getCXX)/" \
		-e "s/gcc/$(tc-getCC)/" \
		-e "s/CXXOPTS = -O3 -m64 -fexpensive-optimizations -ffast-math/CXXOPTS = ${CXXFLAGS}/" \
		-e "s/COPTS = -O3 -m64 -fexpensive-optimizations -ffast-math/COPTS = ${CFLAGS}/" \
		-i arch/${NAMD_ARCH}.arch || die

	sed \
		-e "s/gentoo-libdir/$(get_libdir)/g" \
		-e "s/gentoo-charm/charm-${CHARM_VERSION}/g" \
		-i Makefile || die "Failed gentooizing Makefile."
	sed -e "s/gentoo-libdir/$(get_libdir)/g" -i arch/Linux-x86_64.fftw || die
	sed -e "s/gentoo-libdir/$(get_libdir)/g" -i arch/Linux-x86_64.tcl || die
}

src_configure() {
	# configure
	./config ${NAMD_ARCH} || die
}

src_compile() {
	# build namd
	cd "${S}/${NAMD_ARCH}"
	emake
}

src_install() {
	dodoc announce.txt license.txt notes.txt
	cd "${S}/${NAMD_ARCH}"

	# the binaries
	dobin ${PN}2 psfgen flipbinpdb flipdcd
}

pkg_postinst() {
	echo
	einfo "For detailed instructions on how to run and configure"
	einfo "NAMD please consults the extensive documentation at"
	einfo "http://www.ks.uiuc.edu/Research/namd/"
	einfo "and the NAMD tutorials available at"
	einfo "http://www.ks.uiuc.edu/Training/Tutorials/"
	einfo "Have fun :)"
	echo
}
