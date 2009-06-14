# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit common-lisp-common-3 eutils toolchain-funcs

MY_PV=${PV:0:3}

DESCRIPTION="CMU Common Lisp is an implementation of ANSI Common Lisp"
HOMEPAGE="http://www.cons.org/cmucl/"
SRC_URI="http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-src-${MY_PV}.tar.bz2
	 http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-${MY_PV}-x86-linux.tar.bz2
	 http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/patches/cmucl-${MY_PV}-patch-00${PV/*_p/}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/openmotif
	sys-devel/bc"

PROVIDE="virtual/commonlisp"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch cmucl-${MY_PV}-patch-00${PV/*_p/}
	find "${S}" -type f \( -name \*.sh -o -name linux-nm \) \
		-exec chmod +x '{}' \;
	sed -i -e "s,CC = .*,CC = $(tc-getCC),g" src/lisp/Config.linux_gencgc
	sed -i -e 's,"time","",g' src/tools/build.sh
	sed -i -e "s,@CFLAGS@,$CFLAGS,g" src/lisp/Config.linux_gencgc src/motif/server/Config.x86
	sed -i -e "s,fnstsw\t%eax,fnstsw\t%ax,g" src/lisp/x86-assem.S
	
	if [[ "$(gcc-major-version)" == "4" ]]; then
		sed -i -e "s,\-\I\-,-iquote,g" src/lisp/Config.*
	fi
}

src_compile() {
	src/tools/build.sh -C "" -o "bin/lisp -core lib/cmucl/lib/lisp.core -batch -noinit -nositeinit" || die
}

src_install() {
	src/tools/make-dist.sh -g -G root -O root build-4 ${PV} x86 linux
	dodir /usr/share/doc
	for i in cmucl-${PV}-x86-linux.{,extra.}tar.gz; do
		tar xzpf $i -C "${D}"/usr
	done
	mv "${D}"/usr/doc "${D}"/usr/share/doc/${PF}
	mv "${D}"/usr/man "${D}"/usr/share/
	impl-save-timestamp-hack cmucl || die
}

pkg_postinst() {
	standard-impl-postinst cmucl
}

pkg_postrm() {
	standard-impl-postrm cmucl /usr/bin/lisp
}

