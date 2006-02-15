# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

MY_PV="4.0b7"
DESCRIPTION="Astronomical imaging and data visualization application for FITS images"
HOMEPAGE="http://hea-www.harvard.edu/RD/ds9"
SRC_URI="http://hea-www.harvard.edu/saord/download/${PN}/source/${PN}.${MY_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc xpa"
DEPEND=">=sys-devel/gcc-3.4
        virtual/x11"
RDEPEND="virtual/x11"

S=${WORKDIR}/sao${PN}

# This is a long and fragile compilation
# which recompiles tcl/tk, blt, funtools, and who knows what else
# The make install in src_compile only install and strip the ds9 exec
# One day scientists will use tools like autotools, cmake, scons

src_unpack() {
	unpack ${A}
	cd ${S}
    # The patch is to speed up the compilation
    # (avoid generating tcl man files for ex.) 
    # and avoid local install bugs with symbolic linking.
	epatch ${FILESDIR}/${PN}-Makefile.patch
}

src_compile() {
	! is-flag -fPIC && append-flags -fPIC
	sed -i -e '1i #!/bin/sh' funtools-*/filter/inc.sed
	use x86   && ln -s make.linux make.include
	use amd64 && ln -s make.linux64 make.include
	emake -j1 || die "emake failed"
	# only install locally
	make install || die "make install (local) failed"
}

src_install () {
	dobin bin/ds9
	if use xpa; then
		dobin bin/xpa*
		doman man/man?/xpa*
	fi
	dodoc README acknowledgement copyright
	use doc && dohtml ds9/doc/*
}
