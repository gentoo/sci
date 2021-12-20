# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="JupyterLab's Desktop client in electron"
HOMEPAGE="https://github.com/suyashmahar/europa"
SRC_URI="https://drive.google.com/uc?export=download&id=1c6NYXJgioU4_2v-CQ6oxtb1jzMMhDeMo -> ${P}.tar.xz"

KEYWORDS="-* ~amd64"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/libappindicator
	dev-libs/nspr
	dev-libs/nss
	dev-python/jupyterlab
	media-libs/alsa-lib
	net-print/cups
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXScrnSaver
	x11-libs/pango
"

QA_PREBUILT="/opt/${PN//-bin}*"

S="${WORKDIR}"

src_install() {
	# Move icon to correct dir
	mv usr/share/icons/hicolor/0x0 usr/share/icons/hicolor/256x256 || die
	# Write name in desktop file with capital letter
	sed -i -e 's/Name=europa/Name=Europa/g' usr/share/applications/europa.desktop || die

	mv "${S}"/* "${ED}" || die
}
