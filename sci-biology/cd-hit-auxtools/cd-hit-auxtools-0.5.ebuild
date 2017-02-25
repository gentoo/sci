# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

RELDATE="2012-03-07"
RELEASE="${PN}-v${PV}-${RELDATE}"

DESCRIPTION="Additional cd-hit itools: read-linker, cd-hit-lap and cd-hit-dup"
HOMEPAGE="http://weizhong-lab.ucsd.edu/cd-hit/"
SRC_URI="
	http://cdhit.googlecode.com/files/${RELEASE}.tgz
	http://weizhong-lab.ucsd.edu/cd-hit/wiki/doku.php?id=cd-hit-auxtools-manual -> cd-hit-auxtools-manual.html"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="doc openmp"

S="${WORKDIR}"/${RELEASE}

pkg_setup() {
	 use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

src_prepare() {
	tc-export CXX
	use openmp || append-flags -DNO_OPENMP
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	local myconf=
	use openmp && myconf="openmp=yes"
	emake ${myconf}
}

src_install() {
	dobin read-linker cd-hit-lap cd-hit-dup
	use doc && dodoc "${DISTDIR}"/cd-hit-auxtools-manual.html
}
