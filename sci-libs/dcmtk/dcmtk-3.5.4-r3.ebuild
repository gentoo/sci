# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Libraries and applications implementing large parts the DICOM standard"
HOMEPAGE="http://dicom.offis.de/dcmtk.php.en"
DEB_PV=3 # Debian patch dcmtk_3.5.4-3.diff
SRC_URI="
	ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk354/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PV}.diff.gz"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"
IUSE="doc png ssl tcpd tiff xml zlib"

RDEPEND="
	virtual/jpeg
	png? ( media-libs/libpng )
	ssl? ( dev-libs/openssl )
	tcpd? ( sys-apps/tcp-wrappers )
	tiff? ( media-libs/tiff )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${PN}_3.5.4-3.diff"
}

src_configure() {
	econf \
		--sysconfdir=/etc/dcmtk \
		--with-private-tags \
		$(use_with tiff libtiff) \
		$(use_with zlib) \
		$(use_with png libpng) \
		$(use_with xml libxml) \
		$(use_with tcpd libwrap) \
		$(use_with ssl openssl)
}

src_compile() {
	# Don't compile without ARCH="" ?!
	emake ARCH="" || die "emake failed"
	if use doc; then
		emake html
	fi
}

src_install() {
	if use doc; then
		emake DESTDIR="${D}" install-all \
			install-doc \
			|| die "emake install failed"
	else
		# Note : install-all = install install-lib install-html
		emake DESTDIR="${D}" install \
			install-lib \
			|| die "emake install failed"
	fi
	dodoc FAQ HISTORY *.txt
	if use doc; then
		dohtml "${PN}"/html/*
	fi
}
