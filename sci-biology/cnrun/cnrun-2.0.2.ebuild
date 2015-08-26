# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A NeuroML-enabled, neuronal network simulator w/ conductance- and rate-based HH neurons"
HOMEPAGE="http://johnhommer.com/academic/code/cnrun"
SRC_URI="http://johnhommer.com/academic/code/cnrun/source/${P}.tar.xz"

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
