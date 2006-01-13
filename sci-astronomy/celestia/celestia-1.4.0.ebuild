# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic gnome2 kde-functions

DESCRIPTION="Free space simulation that lets you experience our universe in three dimensions"
HOMEPAGE="http://www.shatters.net/${PN}/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnome gtk kde arts threads nls lua"

DEPEND="virtual/glu
	media-libs/jpeg
	media-libs/libpng
	gtk? ( !gnome? ( !kde? (
		>=x11-libs/gtk+-2.6
		>=x11-libs/gtkglext-1.0
	) ) )
	gnome? ( !kde? (
		>=x11-libs/gtk+-2.6
		>=x11-libs/gtkglext-1.0
		>=gnome-base/libgnomeui-2.0
	) )
	kde?  ( ! gnome ( >=kde-base/kdelibs-3.0.5 ) )
	!gtk? ( !gnome? ( !kde? ( virtual/glut ) ) )
	arts? ( kde-base/arts )
	lua? ( >=dev-lang/lua-5.0 )"

pkg_setup() {
	# Check for one for the following use flags to be set.
	if ! use gnome && use kde; then
		einfo "USE=\"kde\" detected."
		mygui="kde"
	elif ! use kde && use gnome; then
		einfo "USE=\"gnome\" detected."
		USE_DESTDIR="1"
		mygui="gnome"
	elif ! use kde && ! use gnome && use gtk; then
		einfo "USE=\"gtk\" detected."
		mygui="gtk"
	elif use kde && use gnome; then
		einfo "Both gnome and kde support requested. Defaulting to gtk"
		mygui="gtk"
	else
		ewarn "If you want to use the full gui, set USE=\"{kde/gnome/gtk}\""
		ewarn "Defaulting to glut support (no GUI)."
		mygui="glut"
	fi

	einfo "If you experience problems building celestia with nvidia drivers,"
	einfo "you can try:"
	einfo "eselect opengl set xorg-x11"
	einfo "emerge celestia"
	einfo "eselect opengl set nvidia"
}

src_compile() {
	filter-flags "-funroll-loops -frerun-loop-opt"
	addwrite ${QTDIR}/etc/settings

	# remove manual installation in /usr/share/${PN}/manual
	# replaced with dohtml in src_install
	sed -i -e "s:manual::g" Makefile.in

	if [ "${mygui}" = "kde" ]; then
		set-kdedir 3
		set-qtdir 3
		export kde_widgetdir="$KDEDIR/lib/kde3/plugins/designer"
	fi

	econf \
		--with-${mygui} \
		$(use_with arts) \
		$(use_with lua) \
		$(use_enable threads threading) \
		$(use_enable nls) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	if [ "${mygui}" = "gnome" ]; then
		gnome2_src_install
	else
		make install DESTDIR="${D}" \
			|| die "make install failed"
	fi

	dodoc AUTHORS README TODO NEWS TRANSLATORS ChangeLog \
		CelestiaKeyAssignments.txt KbdMouseJoyControls.txt devguide.txt
	dohtml coding-standards.html manual/*.html manual/*.css
}
