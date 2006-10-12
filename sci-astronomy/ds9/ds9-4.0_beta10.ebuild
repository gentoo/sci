# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

MY_PV=${PV/_beta/b}
DESCRIPTION="Data visualization application for astronomical FITS images"
HOMEPAGE="http://hea-www.harvard.edu/RD/ds9"
SRC_URI="http://hea-www.harvard.edu/saord/download/${PN}/source/${PN}.${MY_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND="app-arch/zip"

S=${WORKDIR}/sao${PN}

# This is a long and fragile compilation
# which recompiles tcl/tk, blt, funtools, and who knows what else
# The make install in src_compile only installs and strips the ds9 exec
# One day scientists will use tools like autotools, cmake, scons

src_unpack() {
	unpack ${A}
	cd "${S}"
	# patch to speed up compilation (no man pages generation)
	epatch ${FILESDIR}/${PN}-Makefile.patch
	# patch to fix a cast on 64 bits.
	use amd64 && epatch ${FILESDIR}/${PN}-iis.patch
	# add a line for the shell to understand
	sed -i -e '1i #!/bin/sh' funtools-*/filter/inc.sed
}

src_compile() {
	local ds9arch
	case ${ARCH} in
		x86)
			ds9arch=linux
			;;
		amd64)
			ds9arch=linux64
			;;
		ppc)
			ds9arch=linuxppc
			;;
		ppc-macos)
			ds9arch=darwin
			;;
		x86-fbsd)
			ds9arch=freebsd
			;;
		*) die "ds9 not supported upstream for this architecture";;
	esac

	ln -s make.${ds9arch} make.include
	emake || die "emake failed"
	# only install locally
}

src_install () {
	dobin bin/ds9
	dobin bin/xpa*
	doman man/man?/xpa*
	dodoc README acknowledgement copyright
	use doc && dohtml doc/*
}
