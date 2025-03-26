# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2

DESCRIPTION="Integrand Reduction via Laurent Expansion for one-loop integrals."
HOMEPAGE="https://ninja.hepforge.org/"
SRC_URI="https://ninja.hepforge.org/downloads?f=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND="
	sci-physics/oneloop
	sci-physics/looptools
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Replace #!/bin/sh with #!/bin/bash
	sed -i -e 's:#!/bin/sh:#!/bin/bash:' configure || die
	econf $(use_enable static-libs static)
}

src_compile() {
	# single thread force needed since fortan mods depend on each other
	emake -j1
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
