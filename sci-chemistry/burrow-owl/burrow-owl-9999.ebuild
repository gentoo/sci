# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://burrow-owl.git.sourceforge.net/gitroot/burrow-owl/burrow-owl"
	GIT="git-2"
fi

AUTOTOOLS_AUTORECONF="true"

inherit autotools-utils ${GIT}

SRC_PN="${PN/-owl}"
SRC_P="${SRC_PN}-${PV}"

DESCRIPTION="Visualize multidimensional nuclear magnetic resonance (NMR) spectra"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI="examples? ( mirror://sourceforge/${PN}/${SRC_PN}-demos.tar )"
else
	SRC_URI="
		mirror://sourceforge/${PN}/${SRC_P}.tar.gz
		examples? ( mirror://sourceforge/${PN}/${SRC_PN}-demos.tar )"
	S="${WORKDIR}/${SRC_P}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

RDEPEND="
	dev-scheme/guile-gnome-platform
	>=dev-scheme/guile-cairo-1.4
	>=sci-libs/starparse-1.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/indent
	dev-util/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-no-doc.patch
	"${FILESDIR}"/${PV}-impl-dec.patch
	)

MAKEOPTS+=" -j1"

src_unpack() {
	if [[ ${PV} = 9999* ]]; then
		git-2_src_unpack
		use examples && unpack ${A}
	else
		unpack ${A}
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with doc doxygen)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		pushd "${WORKDIR}"/burrow-demos
		docinto demonstration
		dodoc *
		cd data
		docinto demonstration/data
		dodoc *
		popd
	fi
}
