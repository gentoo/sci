# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic autotools

DESCRIPTION="Chemical quantum mechanics and molecular mechanics"
HOMEPAGE="http://bioinformatics.org/ghemical/"

SRC_URI="http://bioinformatics.org/ghemical/download/current/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="threads openbabel seamonkey"
RDEPEND="virtual/glut
	virtual/glu
	virtual/opengl
	sci-chemistry/mpqc
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/pango
	>=x11-libs/gtk+-2.6
	>=x11-libs/gtkglext-1.0.5
	>=gnome-base/libglade-2.4
	>=sci-libs/libghemical-2.96
	>=x11-libs/liboglappth-0.96
	openbabel? ( >=sci-chemistry/openbabel-2 )
	threads? ( >=dev-libs/glib-2.4 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/ghemical-gcc43.patch" || die "Failed to apply ghemical-gcc43.patch"
	epatch "${FILESDIR}/${P}-import_export-212689.patch" || die "Failed to apply ${P}-import_export-212689.patch"
	epatch "${FILESDIR}/${P}-libf2c_config_test-232292.patch" || die "Failed to apply ${P}-libf2c_config_test-232292.patch"

	eautoreconf
}

src_compile() {

# With amd64, if you want gamess I recommend adding gamess and gtk-gamess to package.provided for now.

# Change the built-in help browser.
	if use seamonkey ; then
		sed -i -e 's|mozilla|seamonkey|g' src/gtk_app.cpp || die "sed failed for seamonkey!"
	else
		sed -i -e 's|mozilla|firefox|g' src/gtk_app.cpp || die "sed failed for seamonkey!"
	fi

	# For libf2c
	append-ldflags -Xlinker -defsym -Xlinker MAIN__=main

	econf \
		$(use_enable openbabel) \
		$(use_enable threads) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
