# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

MYP=${PN}.net-${PV}

DESCRIPTION="Automated astrometric calibration programs and service"
HOMEPAGE="http://astrometry.net/"
SRC_URI="${HOMEPAGE}/downloads/${MYP}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/numpy
	media-libs/libpng
	media-libs/netpbm
	sci-astronomy/wcslib
	sci-libs/cfitsio
	sci-libs/gsl
	sys-libs/zlib
	virtual/jpeg
	x11-libs/cairo"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-as-needed.patch \
		"${FILESDIR}"/${PV}-system-libs.patch \
		"${FILESDIR}"/${PV}-missing-headers.patch \
		"${FILESDIR}"/${PV}-strict-aliasing.patch \
		"${FILESDIR}"/${PV}-respect-user-flags.patch \
		"${FILESDIR}"/${PV}-array-bounds.patch
}


src_compile() {
	emake
	emake extra
}

src_install() {
	emake install INSTALL_DIR="${ED}"/usr/astrometry
	# TODO
	# remove license file
	# system pyfits?
	# some execs are already included in cfitsio (system-libs patch need work)
	# doc/examples in proper directory
	# tests
}
