# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils toolchain-funcs git-r3

DESCRIPTION="exonerate-2.2.0 with patches to add GFF3 formatted output"
HOMEPAGE="https://github.com/hotdogee/exonerate-gff3"
SRC_URI=""
EGIT_REPO_URI="https://github.com/hotdogee/exonerate-gff3.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="utils test threads"

REQUIRED_USE="test? ( utils )"

# block with sci-biology/exonerate , maybe the best would be to change SRC_URI in sci-biology/exonerate
DEPEND="
	!sci-biology/exonerate
	dev-libs/glib:2"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${P}-asneeded.patch )

src_prepare() {
	tc-export CC
	sed \
		-e 's: -O3 -finline-functions::g' \
		-i configure.in || die
	# we patch the configure.in file like sci-biology/exonerate:gentoo does, though it is ugly hack
	# mv configure.in configure.ac
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable utils utilities)
		$(use_enable threads pthreads)
		--enable-largefile
		--enable-glib2
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	doman doc/man/man1/*.1
}
