# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs flag-o-matic multilib

MY_PN="${P}p1.4"

DESCRIPTION="The X Window-System-based Visual/Integrated Environment for Workstations"
HOMEPAGE="http://physionet.caregroup.harvard.edu/physiotools/xview/"
# We usr the debian tarball so that the debian patches apply
SRC_URI="
	mirror://debian/pool/main/x/xview/xview_3.2p1.4.orig.tar.gz
	mirror://debian/pool/main/x/xview/xview_3.2p1.4-28.1.debian.tar.gz"

LICENSE="XVIEW"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux -*"
IUSE="static-libs"

RDEPEND="
	media-fonts/font-bh-75dpi
	media-fonts/font-sun-misc
	x11-libs/libXpm
	x11-misc/xbitmaps
	x11-proto/xextproto"

DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	append-flags -m32
	append-ldflags -m32

	EPATCH_OPTS="-p1"

	epatch \
		"${FILESDIR}"/${P}-impl-dec.patch \
		"${WORKDIR}"/debian/patches/{debian-changes-3.2p1.4-26,display_setting}

	# Do not build xgettext and msgfmt since they are provided by the gettext
	# package. Using the programs provided by xview breaks many packages
	# including vim, grep and binutils.
	sed \
		-e 's/MSG_UTIL = xgettext msgfmt/#MSG_UTIL = xgettext msgfmt/' \
		-i util/Imakefile || die "gettext sed failed"

	# (#120910) Look for imake in the right place
	sed -i -e 's:\/X11::' imake || die "imake sed failed"

	sed -i -e 's:/usr/X11R6:/usr:' config/XView.cf Build-LinuxXView.bash || die

	# Nasty hacks to force CC and CFLAGS
	sed \
		-e "s:^\(IMAKEINCLUDE=.*\)\"$:\1 -DCcCmd=$(tc-getCC)\":" \
		-e "s:usr/lib/X11/config:usr/$(get_libdir)/X11/config:" -i Build-LinuxXView.bash || die
	sed -e "s:\(.*STD_DEFINES =.*\)$:\1 -D_GNU_SOURCE ${CFLAGS}:" -i config/XView.obj || die
	sed -e "s:\(.*define LibXViewDefines .*\)$:\1 -D_GNU_SOURCE ${CFLAGS}:" -i config/XView.cf || die
	sed -e "s:^\(MORECCFLAGS.*\)$:\1 -D_GNU_SOURCE ${CFLAGS}:" -i clients/olvwm-4.1/Imakefile
	sed -e "s:\(-Wl,-soname\):${LDFLAGS} \1:g" -i config/XView.rules || die
}

src_compile() {
	export OPENWINHOME="/usr"
	export X11DIR="/usr"
	export MANDIR="/usr/share/man"

	# This is crazy and I know it, but wait till you read the code in
	# Build-LinuxXView.bash.
	bash Build-LinuxXView.bash libs \
		|| die "building libs failed"
#	bash Build-LinuxXView.bash clients \
#		|| die "building clients failed"
#	bash Build-LinuxXView.bash contrib \
#		|| die "building contrib failed"
#	bash Build-LinuxXView.bash olvwm \
#		|| die "building olvwm failed"
}

src_install() {
	export OPENWINHOME="/usr"
	export X11DIR="/usr"
	export MANDIR="/usr/share/man"
	export DESTDIR="${ED}"

	bash Build-LinuxXView.bash instlibs \
		|| die "installing libs failed"
#	bash Build-LinuxXView.bash instclients \
#		|| die "installing clients failed"
#	bash Build-LinuxXView.bash instcontrib \
#		|| die "installing contrib failed"
#	bash Build-LinuxXView.bash instolvwm \
#		|| die "installing olvwm failed"
#	cd "${ED}"/usr

	use static-libs || \
		find "${ED}" -type f -name "*.a" -delete

	mv "${ED}"/usr/man "${ED}"/usr/share/ || die

	cd "${S}"/doc || die
	dodoc README xview-info olgx_api.txt olgx_api.ps sel_api.txt dnd_api.txt whats_new.ps
	rm -rf "${ED}"/usr/X11R6/share/doc/xview "${ED}"/usr/X11R6/share/doc "${ED}"/usr/bin || die
}
