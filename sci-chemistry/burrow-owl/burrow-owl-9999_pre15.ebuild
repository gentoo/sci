# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

if [[ ${PV} = 9999* ]]; then
	EBZR_REPO_URI="http://oregonstate.edu/~benisong/software/projects/burrow-owl/releases/1.5"
	EBZR_BOOTSTRAP="eautoreconf"
	BZR="bzr"
fi

inherit autotools ${BZR}

SRC_PN="${PN/-owl}"
SRC_P="${SRC_PN}-${PV}"

DESCRIPTION="Visualize multidimensional nuclear magnetic resonance (NMR) spectra"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI="examples? ( mirror://sourceforge/${PN}/${SRC_PN}-demos.tar )"
else
	SRC_URI="mirror://sourceforge/${PN}/${SRC_P}.tar.gz
		examples? ( mirror://sourceforge/${PN}/${SRC_PN}-demos.tar )"
	S="${WORKDIR}/${SRC_P}"
fi
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
RDEPEND="=x11-libs/gtk+-2*
	dev-scheme/guile-gnome-platform
	>=dev-scheme/guile-cairo-1.4
	sci-libs/starparse"
DEPEND="${RDEPEND}
	dev-util/indent
	dev-util/pkgconfig"

EBZR_PATCHES="${PV}-no-doc.patch"

src_unpack() {
	if [[ ${PV} = 9999* ]]; then
		bzr_src_unpack
		use examples && unpack ${A}
	else
		unpack ${A}
	fi
}

src_compile() {
	econf || die
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
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
