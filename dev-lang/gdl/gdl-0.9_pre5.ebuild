# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

MYP=${P/_/}
DESCRIPTION="An Interactive Data Language compatible incremental compiler"
LICENSE="GPL-2"
HOMEPAGE="http://gnudatalanguage.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnudatalanguage/${MYP}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python fftw hdf hdf5 netcdf imagemagick proj"

RDEPEND=">=sys-libs/readline-4.3
	sci-libs/gsl
	>=sci-libs/plplot-5.3
	imagemagick? ( media-gfx/imagemagick )
	hdf? ( sci-libs/hdf )
	hdf5? ( sci-libs/hdf5 )
	netcdf? ( sci-libs/netcdf )
	python? ( virtual/python
			dev-python/numarray
			dev-python/matplotlib )
	fftw? ( sci-libs/fftw )
	proj? ( sci-libs/proj )"

DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/${MYP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-proj4.patch
}

src_compile() {
	use proj && append-cppflags -DPJ_LIB__
	econf \
	  $(use_with python) \
	  $(use_with fftw) \
	  $(use_with hdf) \
	  $(use_with hdf5) \
	  $(use_with netcdf) \
	  $(use_with imagemagick Magick) \
	  $(use_with proj libproj4) \
	  || die "econf failed"

	emake || die "emake failed"
}

src_test() {
	cd ${S}/testsuite
	PATH=${S}/src gdl <<EOF
test_suite
EOF
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/share/${PN}
	doins -r src/pro
	doins -r src/py
	dodoc README PYTHON.txt AUTHORS ChangeLog NEWS TODO HACKING

	# add GDL provided routines to IDL_PATH
	echo "GDL_STARTUP=/usr/share/${PN}/pro" > 99gdl
	echo "GDL_PATH=/usr/share/${PN}" >> 99gdl
	doenvd 99gdl
}
