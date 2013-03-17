# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="The Berkeley UPC Runtime/driver"
HOMEPAGE="http://upc.lbl.gov/"
SRC_URI="http://upc.lbl.gov/download/release/${P}.tar.gz"
LICENSE="BSD-4"

SLOT="0"
KEYWORDS="~x86"
IUSE="mpi mpi-compat pshm +segment-fast segment-large +single +sptr-packed
	sptr-struct sptr-symmetric threads +udp"

REQUIRED_USE="^^ ( segment-fast segment-large )
	^^ ( sptr-packed sptr-struct sptr-symmetric )"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	elog "There is a lot of options for this package,"
	elog "especially network conduits settings."
	elog "You can set them using EXTRA_ECONF variable."
	elog "To see full list of options visit ${HOMEPAGE}download/dist/INSTALL.TXT"
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr/${P} \
		--mandir="${EPREFIX}"/usr/share/man/ \
		--disable-aligned-segments \
		--disable-auto-conduit-detect \
		$(use_enable mpi) \
		$(use_enable mpi-compat) \
		$(use_enable pshm) \
		$(use_enable segment-fast) \
		$(use_enable segment-large) \
		$(use_enable single smp) \
		$(use_enable sptr-packed) \
		$(use_enable sptr-struct) \
		$(use_enable sptr-symmetric) \
		$(use_enable threads par) \
		$(use_enable udp) \
		${EXTRA_ECONF}
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /usr/bin
	dosym ../${P}/bin/upc_trace /usr/bin/upc_trace
	dosym ../${P}/bin/upcc /usr/bin/upcc
	dosym ../${P}/bin/upcdecl /usr/bin/upcdecl
	dosym ../${P}/bin/upcrun /usr/bin/upcrun
}
