# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/ng-spice-rework/ng-spice-rework-17-r1.ebuild,v 1.1 2006/05/12 20:49:03 calchan Exp $

inherit eutils

DESCRIPTION="The Next Generation Spice (Electronic Circuit Simulator)."
SRC_URI="mirror://sourceforge/ngspice/${P}.tar.gz"
HOMEPAGE="http://ngspice.sourceforge.net"
LICENSE="BSD GPL-2"

SLOT="0"
IUSE="readline debug xspice X"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="X? ( || ( (x11-libs/libXaw
					x11-libs/libX11	
				)
					virtual/X11
		))
		readline? ( >=sys-libs/readline-5.0 )"

DEPEND="${RDEPEND}
		X? ( || (  (x11-proto/xproto
				) 
					virtual/X11
		))"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-com_let.patch
	epatch ${FILESDIR}/${PN}-numparam.patch
	epatch ${FILESDIR}/${PN}-pipemode.patch
	epatch ${FILESDIR}/${PN}-postscript.patch
}

src_compile() {
	econf \
		--enable-numparam \
		--enable-dot-global \
		--enable-intnoise \
		--disable-dependency-tracking \
		$(use_with debug) \
		$(use_with readline) \
		$(use_with X) \
		$(use_enable xspice) || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	local infoFile
	for infoFile in doc/ngspice.info*; do
		echo 'INFO-DIR-SECTION EDA' >> ${infoFile}
		echo 'START-INFO-DIR-ENTRY' >> ${infoFile}
		echo '* NGSPICE: (ngspice). Electronic Circuit Simulator.' >> ${infoFile}
		echo 'END-INFO-DIR-ENTRY' >> ${infoFile}
	done

	make DESTDIR="${D}" install || die "make install failed"
	dodoc ANALYSES AUTHORS BUGS ChangeLog DEVICES NEWS \
		README Stuarts_Poly_Notes || die "failed to install documentation"

	# We don't need makeidx to be installed
	rm ${D}/usr/bin/makeidx
}

src_test () {
	# Bug 108405
	true
}
