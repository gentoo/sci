# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit autotools lua-single

DESCRIPTION="A NeuroML-enabled, precise but slow neuronal network simulator"
HOMEPAGE="http://johnhommer.com/academic/code/cnrun"
SRC_URI="http://johnhommer.com/code/cnrun/source/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-libs/libxml2
	sci-libs/gsl"

DEPEND="${RDEPEND}"

src_prepare() {
	default
	# put docs in correct dir
	sed -i -e "s#docdir=\${datarootdir}/doc/lua-cnrun#docdir=\${datarootdir}/doc/${PF}#g" doc/Makefile.am || die
	eautoreconf

}

src_configure() {
	econf --bindir="${EPREFIX}"/bin
}
