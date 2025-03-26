# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2

DESCRIPTION="Integrand Reduction via Laurent Expansion for one-loop integrals."
HOMEPAGE="
	https://github.com/peraro/ninja
	https://ninja.hepforge.org/
"
SRC_URI="
	https://github.com/peraro/ninja/releases/download/v${PV}/${PN}-latest.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs gosam" # quad

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
	local myeconfargs=(
		FCINCLUDE=-I"${ESYSROOT}/usr/include" # oneloop/avholo fortran mods
		--with-looptools
		--with-avholo
		$(use_enable static-libs static)
		$(use_enable gosam)
		#$(use_enable quad quadninja) # not working yet
	)

	CONFIG_SHELL=${ESYSROOT}/bin/bash econf "${myeconfargs[@]}"
}

src_compile() {
	# single thread force needed since fortan mods depend on each other
	emake -j1
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
