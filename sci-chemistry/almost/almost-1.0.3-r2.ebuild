# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils flag-o-matic

DATE="090822"

DESCRIPTION="all atom molecular simulation toolkit"
HOMEPAGE="http://www-almost.ch.cam.ac.uk/site"
#SRC_URI="http://www-almost.ch.cam.ac.uk/site/downloads/${P}.tar.gz"
## Upstream changes tarballs w/o revision bump so I host a copy
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}-${DATE}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=""

## dev-libs/boost-1.3.6, once it is in the tree soft masked
## until then we use the shipped one
# Upstream has to fix its code so that  it compiles with mpicxx
## Upstream only uses sys-cluster/mpich2, so we should first get this to work.
#DEPEND="mpi? ( sys-cluster/mpich2 )"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

src_unpack(){
	unpack ${A}

	cd "${S}"

	rm -rf ./include/almost/boost src/lib/iostreams
#	rm -rf ./include/almost/boost ./include/almost/boost_1_30 #src/lib/iostreams

	sed -e 's:boost boost_1_30::g' \
		-i ./include/almost/Makefile.am

	epatch "${FILESDIR}"/configure2.patch
	epatch "${FILESDIR}"/Makefile.patch

	sed \
		-e '/include\/almost\/boost/d' \
		-e '/include\/almost\/tinyxml/d' \
		-i configure.in

#	find include \
#		-name "*.h" \
#		-exec sed 's:boost_1_30:boost:g' -i '{}' \;

	epatch "${FILESDIR}"/gcc-4.3.patch
	eautoreconf || die "Reconfiguration failed"
}

src_compile(){

	econf || die "configure failed"

	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" -j1 || \
	die "make failed"

}

src_test() {
	emake check || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	insinto /usr/include/${PN}
	doins {almost,config}.h || die "failed to install missing headers"

	dodoc README NEWS TODO ChangeLog AUTHORS
}
