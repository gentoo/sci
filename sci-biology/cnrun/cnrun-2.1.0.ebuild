# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A NeuroML-enabled, precise but slow neuronal network simulator"
HOMEPAGE="http://johnhommer.com/academic/code/cnrun"
SRC_URI="http://alfinston.dlinkddns.com/johnhommer.com/code/cnrun/source/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxml2
	 dev-lang/lua:*
	 sci-libs/gsl"

DEPEND="${RDEPEND}"

src_configure() {
	econf --bindir="${EPREFIX}"/bin
}
