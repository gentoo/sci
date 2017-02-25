# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="convert dssp to pdb"
HOMEPAGE="http://structure.usc.edu/dssp2pdb/"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.tar"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-lang/perl
	sci-chemistry/dssp"
DEPEND=""

S="${WORKDIR}"

src_install() {
	dobin ${PN}
}
