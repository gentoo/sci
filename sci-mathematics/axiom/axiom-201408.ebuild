# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib

DESCRIPTION="Axiom is a general purpose Computer Algebra system"
HOMEPAGE="http://axiom.axiom-developer.org/"
SRC_URI="http://axiom.axiom-developer.org/axiom-website/downloads/axiom-aug2014-src.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# NOTE: Do not strip since this seems to remove some crucial
# runtime paths as well, thereby, breaking axiom
RESTRICT="strip"

# Seems to need a working version of pstricks package these days Bummer: <gmp-5 is needed for the
# interal gcl, otherwise axiom will try to build an internal copy of gmp-4 which fails.
RDEPEND="
	dev-libs/gmp:0=
	x11-libs/libXaw"
DEPEND="${RDEPEND}
	app-text/dvipdfm
	dev-texlive/texlive-pstricks
	sys-apps/debianutils
	sys-process/procps
	virtual/latex-base"

S="${WORKDIR}"/${PN}

src_prepare() {
	append-flags -fno-strict-aliasing
}

src_compile() {
	sed -e "s:X11R6/lib:$(get_libdir):g" -i Makefile.pamphlet \
		|| die "Failed to fix libXpm lib paths"

	# This will fix the internal gmp. This package will stay unkeyworded until this is resolved
	# upstream.
	unset ABI

	# Let the fun begin...
	AXIOM="${S}"/mnt/linux emake -j1
}

src_install() {
	emake DESTDIR="${ED}"/opt/axiom COMMAND="${ED}"/opt/axiom/mnt/linux/bin/axiom install

	mv "${ED}"/opt/axiom/mnt/linux/* "${ED}"/opt/axiom \
		|| die "Failed to mv axiom into its final destination path."
	rm -fr "${ED}"/opt/axiom/mnt \
		|| die "Failed to remove old directory."

	dosym ../../axiom/bin/axiom /usr/bin/axiom

	sed \
		-e "2d;3i AXIOM=/opt/axiom" \
		-i "${D}"/opt/axiom/bin/axiom \
		|| die "Failed to patch axiom runscript!"

	dodoc changelog readme faq
}
