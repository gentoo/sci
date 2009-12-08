# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib

DESCRIPTION="Guile Scheme code that wraps the GNOME developer platform"
HOMEPAGE="http://www.gnu.org/software/guile-gnome"
SRC_URI="http://ftp.gnu.org/pub/gnu/guile-gnome/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-scheme/guile-1.6.4
	>=dev-libs/g-wrap-1.9.11
	dev-scheme/guile-cairo
	dev-libs/atk
	gnome-base/libbonobo
	gnome-base/orbit
	>=gnome-base/gconf-2.18
	>=dev-libs/glib-2.10
	>=gnome-base/gnome-vfs-2.16
	>=x11-libs/gtk+-2.10
	>=gnome-base/libglade-2.6
	>=gnome-base/libgnomecanvas-2.14
	>=gnome-base/libgnomeui-2.16
	>=x11-libs/pango-1.14
	dev-scheme/guile-lib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

#needs guile with networking
RESTRICT=test

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-guile-gnome-platform_conflicting_types.patch
}

src_configure() {
	econf --disable-Werror
}

src_compile() {
	emake guilegnomedir=/usr/share/guile/site \
		guilegnomelibdir=/usr/$(get_libdir) || die "emake failed."
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		guilegnomedir=/usr/share/guile/site \
		guilegnomelibdir=/usr/$(get_libdir) \
		install || die "emake install failed."
}
