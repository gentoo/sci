# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast strong hash functions: SipHash/HighwayHash"
HOMEPAGE="https://github.com/google/highwayhash"
COMMIT="14dedecd1de87cb662f7a882ea1578d2384feb2f"
SRC_URI="https://github.com/google/highwayhash/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i "/CXXFLAGS/s/-O3/${CXXFLAGS}/" Makefile || die
	default
}

src_install() {
	emake DESTDIR="${D}" INCDIR="${EPREFIX}/usr/include" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	use static-libs || rm "${D}/${EPREFIX}/usr/$(get_libdir)"/lib*.a || die
	einstalldocs
}
