# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AMBER99SBnmr1-ILDN FF (Lindorff-Larsen et al., Proteins 78, 1950-58, 2010)"
HOMEPAGE="https://research.cbc.osu.edu/bruschweiler.1/protein-force-field/"
SRC_URI="https://research.cbc.osu.edu/bruschweiler.1/wp-content/uploads/2013/09/nmr1-ildn.tar -> ${P}.tar"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

RESTRICT="strip binchecks"

src_install() {
	insinto /usr/share/gromacs/top/
	dodoc */*.doc
	rm */*.doc || die
	doins -r *
}
