# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fast strong hash functions: SipHash/HighwayHash"
HOMEPAGE="https://github.com/google/highwayhash"
COMMIT="bdd572de8cfa3a1fbef6ba32307c2629db7c4773"
SRC_URI="https://github.com/google/highwayhash/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_prepare() {
	sed -i "/CXXFLAGS/s/-O3/${CXXFLAGS}/" Makefile || die
	default
}

src_install() {
	emake DESTDIR="${ED}"\
		INCDIR="/usr/include" \
		LIBDIR="/usr/$(get_libdir)" \
		install
	use static-libs || \
		rm "${ED}/usr/$(get_libdir)"/lib*.a || die
	einstalldocs
}
