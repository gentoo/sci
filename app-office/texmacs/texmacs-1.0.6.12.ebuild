# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils
MY_P=${P/tex/TeX}-src
DESCRIPTION="Wysiwyg text processor with high-quality maths"

SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/targz/${MY_P}.tar.gz
	ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-600dpi-fonts.tar.gz"

HOMEPAGE="http://www.texmacs.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="imlib jpeg svg netpbm spell"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/latex-base
	virtual/ghostscript
	>=dev-scheme/guile-1.4
	media-libs/freetype
	x11-libs/libXext
	imlib? ( media-libs/imlib2 )
	jpeg? ( || ( media-gfx/imagemagick media-gfx/jpeg2ps ) )
	svg? ( || ( media-gfx/inkscape gnome-base/librsvg ) )
	netpbm? ( media-libs/netpbm )
	spell? ( || ( >=app-text/ispell-3.2 >=app-text/aspell-0.5 ) )"

DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if has_version ">=dev-scheme/guile-1.8"; then
		if ! built_with_use dev-scheme/guile deprecated; then
			eerror "Please re-emerge dev-scheme/guile with the USE flag +deprecated"
			die "Bad guile version"
		fi
	fi
}

src_compile() {
	econf $(use_with imlib imlib2 ) \
		--enable-optimize="${CXXFLAGS}" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc TODO || die "dodoc failed"
	domenu "${FILESDIR}/TeXmacs.desktop" || die "domenu failed"

	# now install the fonts
	insinto /usr/share/texmf
	doins -r "${WORKDIR}/fonts" || die "installing fonts failed"
}
