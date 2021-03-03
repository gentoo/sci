# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="The Berkeley UPC-to-C translator"
HOMEPAGE="https://upc.lbl.gov/"
SRC_URI="https://upc.lbl.gov/download/release/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-shells/tcsh
	sys-devel/bison
"

PATCHES=( "${FILESDIR}"/${PN}-2.28.0-makefile.patch )

src_prepare() {
	default

	# makefiles unset CFLAGS and CXXFLAGS
	export CXX="$(tc-getCXX) -std=gnu++98 "
	tc-export CC

	export  BUPC_ABI="${BUPC_ABI:-LP64}" \
		BUPC_BUILDDIR="${BUPC_BUILDDIR:-build_ia64}"
}

src_configure() {
	# their configure is broken
	# patch should be enough to counter most
	return
}

src_compile() {
	ABI="${BUPC_ABI}" BUILDDIR="${BUPC_BUILDDIR}" \
	emake -j1 all
}

src_install() {
	ABI="${BUPC_ABI}" BUILDDIR="${BUPC_BUILDDIR}" \
	PREFIX="${ED}/usr/libexec/${P}/" \
	emake -j1 install
}
