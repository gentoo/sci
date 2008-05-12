# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit versionator eutils autotools

DESCRIPTION="Math Graphics Library"
IUSE="fltk glut jpeg tiff hdf5 doc linguas_ru"
HOMEPAGE="http://mathgl.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"

DOC=${PN}-$(get_version_component_range 1-2 )

SRC_URI="mirror://sourceforge/${PN}/${P}.tgz
	mirror://sourceforge/${PN}/STIX_font.tgz
	doc? ( mirror://sourceforge/${PN}/${DOC}-eng.pdf
		linguas_ru? ( mirror://sourceforge/${PN}/${DOC}-rus.pdf ) )"

DEPEND="sci-libs/gsl
	virtual/glu
	fltk? ( x11-libs/fltk )
	glut? ( virtual/glut )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	hdf5? ( sci-libs/hdf5 )"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT=mirror

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv ../*.vfm fonts/

	epatch "${FILESDIR}"/${PN}-fltk.patch

	# Remove ru_RU.cp1251
	epatch "${FILESDIR}"/${PN}-no-cp1251.patch

	sed -e "s:-O2:${CPPFLAGS}:g" -i mgl/Makefile.am
	sed -e "s:-O2:${CPPFLAGS}:g" -i examples/Makefile.am
	sed -e "s:-O2:${CPPFLAGS}:g" -i utils/Makefile.am

	eautoreconf
}

src_compile() {
	econf $(use_enable fltk ) \
		$(use_enable glut ) \
		$(use_enable jpeg ) \
		$(use_enable tiff ) \
		$(use_enable hdf5 ) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS || die "dodoc failed"

	if use doc; then
		insinto /usr/share/doc/${P}
		doins "${DISTDIR}"/${DOC}-eng.pdf
		use linguas_ru && doins "${DISTDIR}"/${DOC}-rus.pdf
	fi
}
