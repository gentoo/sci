# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/x11-libs/xview/Attic/xview-3.2-r6.ebuild,v 1.6 2008/12/21 09:03:33 ssuominen dead $

inherit eutils toolchain-funcs

MY_PN="${P}p1.4-19c"
GCC_PATCHVER="0.1"

DESCRIPTION="The X Window-System-based Visual/Integrated Environment for Workstations"
HOMEPAGE="http://physionet.caregroup.harvard.edu/physiotools/xview/"
LICENSE="XVIEW"
# We use the xview tarball available from the X organization, but xfree86 appears
# to be up and available more often so we use that (it's their primary mirror).
SRC_URI="http://physionet.caregroup.harvard.edu/physiotools/xview/src/${MY_PN}.tar.gz
		mirror://gentoo/${P}-gcc-4.1-v${GCC_PATCHVER}.patch.bz2"
		# mirror://debian/pool/main/x/xview/${SRC_PATCH}.gz

SLOT="0"
IUSE=""
KEYWORDS="-alpha -amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/libXpm
	x11-proto/xextproto
	media-fonts/font-bh-75dpi
	media-fonts/font-sun-misc
	x11-misc/xbitmaps"

DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# This is our compound patch derived from debian. We use it because:
	#  * xview is a contribution made by Sun Microsystems (?) to the X community,
	#    but fixes for it don't appear to be around other than in the other free
	#    distributions.
	#  * It does little harm, only some defaults are changed which we can redefine
	#    anyway.
	#
	# SRC_PATCH="${PN}_3.2p1.4-16woody2.diff"
	epatch "${FILESDIR}"/lseek.diff
	epatch "${DISTDIR}"/${P}-gcc-4.1-v${GCC_PATCHVER}.patch.bz2

	# Do not build xgettext and msgfmt since they are provided by the gettext
	# package. Using the programs provided by xview breaks many packages
	# including vim, grep and binutils.
	sed -e 's/MSG_UTIL = xgettext msgfmt/#MSG_UTIL = xgettext msgfmt/' \
		-i util/Imakefile || die "gettext sed failed"

	# (#120910) Look for imake in the right place
	sed -i -e 's:\/X11::' imake || die "imake sed failed"

	sed -i -e 's:/usr/X11R6:/usr:' "${S}/config/XView.cf" "${S}/Build-XView.bash"

	# Nasty hacks to force CC and CFLAGS
	sed -e "s:^\(IMAKEINCLUDE=.*\)\"$:\1 -DCcCmd=$(tc-getCC)\":" \
		-e "s:usr/lib/X11/config:usr/$(get_libdir)/X11/config:" -i Build-XView.bash
	sed -e "s:\(.*STD_DEFINES =.*\)$:\1 -D_GNU_SOURCE ${CFLAGS}:" -i config/XView.obj
	sed -e "s:\(.*define LibXViewDefines .*\)$:\1 -D_GNU_SOURCE ${CFLAGS}:" -i config/XView.cf
	sed -e "s:^\(MORECCFLAGS.*\)$:\1 -D_GNU_SOURCE ${CFLAGS}:" -i clients/olvwm-4.1/Imakefile
}

src_compile() {
	export OPENWINHOME="/usr"
	export X11DIR="/usr"

	# This is crazy and I know it, but wait till you read the code in
	# Build-XView.bash.
	bash Build-XView.bash libs \
		|| die "building libs failed"
	bash Build-XView.bash clients \
		|| die "building clients failed"
	bash Build-XView.bash contrib \
		|| die "building contrib failed"
	bash Build-XView.bash olvwm \
		|| die "building olvwm failed"
}

src_install() {
	export OPENWINHOME="/usr"
	export X11DIR="/usr"
	export DESTDIR="${D}"

	bash Build-XView.bash instlibs \
		|| die "installing libs failed"
	bash Build-XView.bash instclients \
		|| die "installing clients failed"
	bash Build-XView.bash instcontrib \
		|| die "installing contrib failed"
	bash Build-XView.bash instolvwm \
		|| die "installing olvwm failed"
	cd "${D}"/usr

	# The rest of the docs is already installed
	cd "${S}"/doc
	dodoc README xview-info olgx_api.txt olgx_api.ps sel_api.txt \
		dnd_api.txt whats_new.ps
	rm -rf "${D}"/usr/X11R6/share/doc/xview && rm -rf "${D}"/usr/X11R6/share/doc
}
