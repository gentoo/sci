# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Shifts Predicted from Analogy in Residue type and Torsion Angle with neural"
HOMEPAGE="http://spin.niddk.nih.gov/bax//software/SPARTA+/"
SRC_URI="http://spin.niddk.nih.gov/bax/software/SPARTA+/sparta+.tar.Z -> ${P}.tar.Z"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="as-is"
IUSE=""

S="${WORKDIR}"/SPARTA+

src_install() {
	sed "s:DIR_HERE:\"${EPREFIX}/opt/${PN}\":g" -i ${PN} || die
	dobin ${PN} || die

	mv bin/SPARTA+{.linux9,} || die
	rm -f bin/SPARTA+.* || die

	insinto /opt/${PN}
	doins -r * || die
	fperms 755 /opt/${PN}/bin/SPARTA+ || die
}
