# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/monomer-db/monomer-db-5.32.ebuild,v 1.2 2011/11/21 15:24:59 jlec Exp $

EAPI=5

MY_PN="refmac_dictionary"

DESCRIPTION="Monomer library used for macromolecular structure building and refinement"
HOMEPAGE="http://www2.mrc-lmb.cam.ac.uk/groups/murshudov/"
SRC_URI="http://www2.mrc-lmb.cam.ac.uk/groups/murshudov/content/refmac/Dictionary/${MY_PN}_v${PV}.tar.gz"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="!<sci-chemistry/ccp4-6.1.3"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"

S="${WORKDIR}"/monomers

src_install() {
	insinto /usr/share/ccp4/data/monomers/
	for i in {a..z} {0..9} *list *.cif *.txt; do
		einfo "Installing ${i}** ..."
		doins -r ${i}
	done
	dodoc *.txt
}
