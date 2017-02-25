# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Whole genome association analysis toolset"
HOMEPAGE="http://pngu.mgh.harvard.edu/~purcell/plink
	https://www.cog-genomics.org/plink2/"
SRC_URI="https://www.cog-genomics.org/static/bin/plink160731/plink_src.zip -> ${P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lapack"

DEPEND="
	app-arch/unzip
	virtual/pkgconfig"
RDEPEND="
	sys-libs/zlib
	lapack? ( virtual/lapack
		virtual/cblas )"

S="${WORKDIR}/"

# Package collides with net-misc/putty. Renamed to p-link following discussion with Debian.
# Package contains bytecode-only jar gPLINK.jar. Ignored, notified upstream.

src_prepare() {
	rm -rf zlib-1.2.8 || die
	sed \
		-e 's:zlib-1.2.8/zlib.h:zlib.h:g' \
		-i *.{c,h} || die

	sed \
		-e 's:g++:$(CXX):g' \
		-e 's:gcc:$(CC):g' \
		-e 's:gfortran:$(FC):g' \
		-i Makefile || die
	if ! use lapack; then
		sed -e 's/^NO_LAPACK =/NO_LAPACK = 1/' -i Makefile || die
		sed -e 's@^// #define NOLAPACK@#define NOLAPACK@' -i plink_common.h || die
	fi
	tc-export PKG_CONFIG
}

src_compile() {
	local blasflags
	use lapack && blasflags="$($(tc-getPKG_CONFIG) --libs lapack cblas)"
	emake \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		ZLIB="$($(tc-getPKG_CONFIG) --libs zlib)" \
		BLASFLAGS="$blasflags"
}

src_install() {
	newbin plink p-link
}

pkg_postinst(){
	einfo "plink binary is now renamed to p-link to avoid file collision"
}
