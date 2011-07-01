# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Command line utilities for operating on netCDF files"
HOMEPAGE="http://nco.sourceforge.net/"
SRC_URI="http://dust.ess.uci.edu/nco/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc gsl mpi ncap2 static-libs udunits"

RDEPEND="
	>=sci-libs/netcdf-4
	gsl? ( sci-libs/gsl )
	mpi? ( virtual/mpi )
	udunits? ( >=sci-libs/udunits-2 )"
DEPEND="${RDEPEND}
	ncap2? ( !mpi? ( dev-java/antlr:0 ) )
	doc? ( virtual/latex-base )"

pkg_setup() {
	if use mpi && use ncap2; then
		elog "mpi and ncap2 are still incompatible flags"
		elog "nco configure will automatically disables ncap2"
	fi
}

src_configure() {
	local myconf
	if has_version '>=sci-libs/netcdf-4[hdf5]'; then
		myconf="--enable-netcdf4"
	else
		myconf="--disable-netcdf4"
	fi
	econf \
		${myconf} \
		--disable-udunits \
		$(use_enable gsl) \
		$(use_enable mpi) \
		$(use_enable ncap2) \
		$(use_enable static-libs static) \
		$(use_enable udunits udunits2)
}

src_compile() {
	# TODO: workout -j1 (probably lex crap race condition)
	emake -j1
	cd doc
	emake clean info
	use doc && VARTEXFONTS="${T}/fonts" emake html pdf
}

src_install() {
	emake DESTDIR="${D}" install
	cd doc
	dodoc ANNOUNCE ChangeLog MANIFEST NEWS README TAG TODO VERSION *.txt
	doinfo *.info*
	use doc && dohtml nco.html/* && dodoc nco.pdf
}
