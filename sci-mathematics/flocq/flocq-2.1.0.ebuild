# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="A floating-point formalization for the Coq system"
HOMEPAGE="http://flocq.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/30884/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sci-mathematics/coq"
RDEPEND="${DEPEND}"

src_configure() {
	econf --libdir="$(coqc -where)/user-contrib/Flocq"
}
