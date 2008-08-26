# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit versionator eutils autotools flag-o-matic

DESCRIPTION="Math Graphics Library"
IUSE="fltk glut jpeg tiff hdf5 doc linguas_ru"
HOMEPAGE="http://mathgl.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DOC=${PN}-$(get_version_component_range 1-2 )

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/STIX_font.tgz
	doc? ( mirror://sourceforge/${PN}/eng_refman.pdf )"

DEPEND="sci-libs/gsl
	virtual/glu
	fltk? ( x11-libs/fltk )
	glut? ( virtual/glut )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	hdf5? ( sci-libs/hdf5 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv ../*.vfm fonts/
}

src_compile() {
	use fltk && append-cppflags $(fltk-config --cflags)
	use fltk && append-ldflags $(fltk-config --ldflags)
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
		doins "${DISTDIR}"/eng_refman.pdf
		use linguas_ru && doins "${DISTDIR}"/${DOC}-rus.pdf
	fi
}
