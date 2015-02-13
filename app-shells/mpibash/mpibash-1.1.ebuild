# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Parallel scripting right from the Bourne-Again Shell (Bash)"
HOMEPAGE="http://www.ccs3.lanl.gov/~pakin/software/mpibash-4.3.html"
SRC_URI="https://github.com/losalamos/MPI-Bash/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="virtual/mpi
	app-shells/bash[plugins]
	sys-cluster/libcircle"
RDEPEND="${DEPEND}"

src_configure() {
	econf --with-bashdir="${EPREFIX}"/usr/include/bash-plugins
}

src_install() {
	default
	use examples || rm -r "${ED}/usr/share/doc/${PF}/examples" || die
}
