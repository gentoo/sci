# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/celestia/celestia-1.3.2.ebuild,v 1.4 2005/09/03 22:46:31 eradicator Exp $

inherit eutils flag-o-matic gnome2 kde-functions

DESCRIPTION="real-time space simulation that lets you experience our universe in three dimensions"
HOMEPAGE="http://www.shatters.net/celestia/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gnome gtk kde arts"

DEPEND="virtual/glut
	virtual/glu
	media-libs/jpeg
	media-libs/libpng
	dev-lang/lua
	gtk? ( >=x11-libs/gtk+-2.0 >=x11-libs/gtkglext-1.0 )
	!gnome? ( !kde? ( >=x11-libs/gtk+-2.0 >=x11-libs/gtkglext-1.0 ) )
	gnome? ( >=gnome-base/libgnomeui-2.0 )
	kde? (
		>=kde-base/kdelibs-3.0.5
		arts? ( kde-base/arts )
	)"

pkg_setup() {
	# Check for one for the following use flags to be set.
	if use kde ; then
		einfo "USE=\"kde\" detected. This will override any gnome/gtk USE preferences."
		export MYMAKE="kde"
	elif use gnome ; then
		einfo "USE=\"gnome\" detected."
		export MYMAKE="gnome"
	elif use gtk ; then
		einfo "USE=\"gtk\" detected."
		export MYMAKE="gtk"
	else
		ewarn "You should set at least one of USE=\"{kde/gnome/gtk}\""
		ewarn "Defaulting to gtk support."
		export MYMAKE="gtk"
	fi

	# Get X11 implementation
	X11_IMPLEM_P="$(best_version virtual/x11)"
	X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
	X11_IMPLEM="${X11_IMPLEM##*\/}"

	einfo "Please note:"
	einfo "if you experience problems building celestia with nvidia drivers,"
	einfo "you can try:"
	einfo "eselect opengl set xorg-x11"
	einfo "emerge celestia"
	einfo "eselect opengl set nvidia"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# adding gcc-3.4 support as posted in
	# (http://bugs.gentoo.org/show_bug.cgi?id=53479#c2)
	epatch "${FILESDIR}"/resmanager.h.patch \

	! use arts && epatch "${FILESDIR}"/celestia-1.3.2-noarts.patch

	if [ "${MYMAKE}" != "gnome" ]; then
		# alright this snapshot seems to have some trouble with installing a
		# file properly. It wants to install celestia.schemas in / which leads
		# to an ACCESS VIOLATION. Unfortunately this file even gets installed
		# when no gtk/gnome is enabled
		# The following lines prevents this but thinkabout as a dirty hack
		cd ${S}/src/celestia/gtk || die
		sed -i -e 's:@GCONF_SCHEMA_FILE_DIR@:$(pkgdatadir)/schemas:g' \
		Makefile.in || die
		sed -i -e 's:@GCONF_SCHEMA_FILE_DIR@:$(pkgdatadir)/schemas:g' \
		data/Makefile.in || die
	fi
}

src_compile() {
	filter-flags "-funroll-loops -frerun-loop-opt"
	addwrite ${QTDIR}/etc/settings

	if [ "${MYMAKE}" = "kde" ]; then
		set-kdedir 3
		set-qtdir 3
		export kde_widgetdir="$KDEDIR/lib/kde3/plugins/designer"
	fi

	./configure \
		--prefix=/usr \
		--with-lua \
		--with-${MYMAKE} || die "configure failed"
	emake all || die
}

src_install() {
	if [ "${MYMAKE}" = "gnome" ]; then
		gnome2_src_install
	else
		make install prefix="${D}"/usr || die
	fi

	dodoc AUTHORS README TODO controls.txt
	dohtml manual/*.html manual/*.css
}
