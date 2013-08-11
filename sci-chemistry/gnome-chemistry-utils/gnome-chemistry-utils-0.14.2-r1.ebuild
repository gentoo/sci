# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

GCONF_DEBUG="no"
inherit eutils gnome2 versionator

DESCRIPTION="Programs and library containing GTK widgets and C++ classes related to chemistry"
HOMEPAGE="http://gchemutils.nongnu.org/"
SRC_URI="http://download.savannah.gnu.org/releases/gchemutils/$(get_version_component_range 1-2)/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3 FDL-1.3"
IUSE="gnumeric nls"

RDEPEND="
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-libs/glib-2.26.0:2
	>=dev-libs/libxml2-2.4.16:2
	>=gnome-extra/libgsf-1.14.9
	>=sci-chemistry/bodr-5
	>=sci-chemistry/chemical-mime-data-0.1.94
	>=sci-chemistry/openbabel-2.3.0
	>=x11-libs/cairo-1.6.0
	>=x11-libs/gdk-pixbuf-2.22.0
	>=x11-libs/goffice-0.10.4
	x11-libs/gtk+:3
	>=x11-libs/libX11-1.0.0
	gnumeric? ( >=app-office/gnumeric-1.11.6 )"
DEPEND="
	virtual/pkgconfig
	app-doc/doxygen"

RESTRICT="mirror"

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--disable-mozilla-plugin
		--disable-update-databases
	)
	gnome2_src_configure ${myeconfargs[@]}
}
