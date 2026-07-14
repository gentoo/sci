# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

DESCRIPTION="A library for evaluating one-loop integrals"
HOMEPAGE="https://www.nikhef.nl//~t68/ff/"

SRC_URI="http://www.nikhef.nl/~t68/ff/ff.tar.gz -> ${P}.tar.gz" # weird hepforge download names
S="${WORKDIR}/${PN}"
KEYWORDS="~amd64"

LICENSE="GPL-2"
SLOT="0"

src_compile() {
	emake FFLAGS="-std=legacy ${FFLAGS}"
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)"
	emake DEST="${D}/usr/$(get_libdir)" install
}

