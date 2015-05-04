# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AT_M4DIR="."

inherit eutils autotools-utils

DESCRIPTION="High quality rendering engine library for C++"
HOMEPAGE="http://antigrain.com/"
SRC_URI="http://antigrain.com/${P}.tar.gz"

LICENSE="GPL-2 gpc? ( free-noncomm )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+gpc sdl static-libs +truetype +X"

# preffer X with enabled xcb, really
RDEPEND="
	sdl? ( >=media-libs/libsdl-1.2.0 )
	X? ( || (  <x11-libs/libX11-1.3.99.901[xcb]
			  >=x11-libs/libX11-1.3.99.901 ) )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( readme authors ChangeLog news )

# patches taken from fedora
PATCHES=(
	"${FILESDIR}"/${PV}/agg-2.4-depends.patch
	"${FILESDIR}"/${PV}/agg-2.5-pkgconfig.patch
	"${FILESDIR}"/${PV}/agg-2.5-autotools.patch
	"${FILESDIR}"/${PV}/agg-2.5-sdl-m4.patch
	"${FILESDIR}"/${PV}/agg-2.5-sdl-automagic.patch
	"${FILESDIR}"/${PV}/0001-Fix-non-terminating-loop-conditions-when-len-1.patch
	"${FILESDIR}"/${PV}/0002-Cure-recursion-by-aborting-if-the-co-ordinates-are-t.patch
	"${FILESDIR}"/${PV}/0003-Get-coordinates-from-previous-vertex-if-last-command.patch
	"${FILESDIR}"/${PV}/0004-Make-rasterizer_outline_aa-ignore-close_polygon-when.patch
	"${FILESDIR}"/${PV}/0005-Remove-VC-6-workaround.patch
	"${FILESDIR}"/${PV}/0006-Implement-grain-merge-blending-mode-GIMP.patch
	"${FILESDIR}"/${PV}/0007-Implement-grain-extract-blending-mode-GIMP.patch
	"${FILESDIR}"/${PV}/0008-Declare-multiplication-and-division-operators-as-con.patch
	"${FILESDIR}"/${PV}/0009-Add-a-static-identity-transformation.patch
	"${FILESDIR}"/${PV}/0010-Add-renderer_scanline_aa_alpha.patch
	"${FILESDIR}"/${PV}/0011-Avoid-division-by-zero-in-color-burn-mode.patch
	"${FILESDIR}"/${PV}/0012-Avoid-pixel-artifacts-when-compositing.patch
	"${FILESDIR}"/${PV}/0013-Modify-agg-conv-classes-to-allow-access-to-the-origi.patch
	"${FILESDIR}"/${PV}/0014-Avoid-potential-zero-division-resulting-in-nan-in-ag.patch
	"${FILESDIR}"/${PV}/0015-Ensure-first-value-in-the-gamma-table-is-always-zero.patch
)

src_configure() {
	local myeconfargs=(
		--disable-ctrl
		--disable-examples
		--disable-dependency-tracking
		$(use_enable gpc)
		$(use_enable sdl)
		$(use_enable truetype freetype)
		$(use_with X x)
	)
	autotools-utils_src_configure
}
