# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="tk threads"

DESCRIPTION="A set of extensions to TCL"
HOMEPAGE="http://tclx.sourceforge.net"
SRC_URI="mirror://sourceforge/tclx/${PN}${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/tcl-8.4.6
tk? ( >=dev-lang/tk-8.4.6 )"

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-relid.patch
	epatch ${FILESDIR}/${P}-varinit.patch
}

src_compile() {
	econf \
		$(use_enable tk) \
		$(use_enable threads) \
		$(use_enable amd64 64bits) \
		--enable-shared \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	cd "${S}"
	dodoc ChangeLog README
	doman doc/*.[n3]
}
