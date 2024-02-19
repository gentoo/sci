# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Higher Order Perturbative Parton Evolution Toolkit"
HOMEPAGE="
	https://hoppet.hepforge.org/
	https://github.com/gavinsalam/hoppet
"
SRC_URI="https://hoppet.hepforge.org/downloads/${P}.tgz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/fortran
"

src_configure() {
	default
	# own custom configure
	./configure --prefix="${EPREFIX}"/usr FFLAGS="${FFLAGS} -fPIC" || die
}

src_compile() {
	emake
}

src_install() {
	# Fix install to ED
	sed -i "s#scripts/install-sh hoppet-config#\##g" Makefile || die
	sed -i "s#/usr/lib/libhoppet#${ED}/usr/$(get_libdir)/libhoppet#g" src/Makefile || die
	sed -i "s#/usr/include/hoppet#${ED}/usr/include/hoppet#g" src/Makefile || die
	emake install
	emake install-mod
	dobin hoppet-config
	find "${ED}" -name '*.la' -delete || die
}
