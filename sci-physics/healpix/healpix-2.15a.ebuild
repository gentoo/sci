# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
MYP="Healpix_${PV}"
MYPP="2010Jun18"

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere."
HOMEPAGE="http://healpix.jpl.nasa.gov/index.shtml"
SRC_URI="mirror://sourceforge/${PN}/${MYP}/${MYP}_${MYPP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd86 ~x86"

IUSE="fortran idl java"
DEPEND=">=sci-libs/cfitsio-3
	fortran? ( media-libs/gd )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MYP}"

src_configure() {
	econf \
	  $(use_enable fortran) \
	  $(use_enable idl) \
	  $(use_enable java)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
