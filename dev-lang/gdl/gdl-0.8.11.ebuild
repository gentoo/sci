# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An Interactive Data Language compatible incremental compiler"
HOMEPAGE="http://gnudatalanguage.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnudatalanguage/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="python fftw hdf hdf5 imagemagick netcdf"

DEPEND=">=sys-libs/readline-4.3
	sci-libs/gsl
	>=sci-libs/plplot-5.3
	imagemagick? ( media-gfx/imagemagick )
	hdf? ( sci-libs/hdf )
	hdf5? ( sci-libs/hdf5 )
	netcdf? ( sci-libs/netcdf )
	python? ( >=dev-lang/python
	          >=dev-python/numarray
	          >=dev-python/matplotlib )
	fftw? ( sci-libs/fftw )"

src_compile() {
	econf \
	  $(use_with imagemagick Magick ) \
	  $(use_with hdf ) \
	  $(use_with hdf5 ) \
	  $(use_with netcdf ) \
	  $(use_with python ) \
	  $(use_with fftw ) \
	  || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	insinto /usr/share/${PN}
	doins -r src/pro
	doins -r src/py
	dodoc README PYTHON.txt AUTHORS ChangeLog NEWS TODO
	echo "IDL_STARTUP=/usr/share/${PN}/pro" > 99gdl
	doenvd 99gdl
}
