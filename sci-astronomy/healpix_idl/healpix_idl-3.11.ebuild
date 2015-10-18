# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MYP="Healpix_${PV}"
MYPP="2013Apr24"

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere - IDL routines"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}/${MYP}_${MYPP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc"

RDEPEND="
	dev-lang/gdl
	sci-astronomy/idlastro"

S="${WORKDIR}/${MYP}/src/idl"

src_prepare() {
	# duplocate of idlastro (in rdeps)
	rm -r zzz_external/astron || die
	mv zzz_external/README README.external || die
}

src_install() {
	insinto /usr/share/gnudatalanguage/healpix
	doins -r examples fits interfaces misc toolkit visu zzz_external
	doins HEALPix_startup
	dodoc README.*
}
