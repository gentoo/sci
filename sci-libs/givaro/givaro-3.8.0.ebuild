# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="https://forge.imag.fr/frs/download.php/592/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc64"
IUSE=""

RDEPEND=">=dev-libs/gmp-4.1-r1:0="
DEPEND="${RDEPEND}"

src_configure(){
	econf "--enable-shared"
}
