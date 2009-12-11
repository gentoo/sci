# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base

DESCRIPTION="Visualize multidimensional nuclear magnetic resonance (NMR) spectra"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
SRC_URI="examples? ( mirror://sourceforge/${PN}/burrow-demos.tar )
		mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-scheme/guile-gnome-platform
	>=dev-scheme/guile-cairo-1.4
	>=sci-libs/starparse-1.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/indent
	dev-util/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-include.patch
	)

src_install() {
	base_src_install
	if use examples; then
		pushd "${WORKDIR}"/burrow-demos
		docinto demonstration
		dodoc * || die "dodoc demo failed"
		cd data
		docinto demonstration/data
		dodoc * || die "dodoc data failed"
		popd
	fi
}
