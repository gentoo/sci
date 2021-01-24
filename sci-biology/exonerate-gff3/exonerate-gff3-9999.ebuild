# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs git-r3

DESCRIPTION="exonerate-2.2.0 with patches to add GFF3 formatted output"
HOMEPAGE="https://github.com/hotdogee/exonerate-gff3"
EGIT_REPO_URI="https://github.com/hotdogee/exonerate-gff3.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="utils test threads"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( utils )"

# block with sci-biology/exonerate , maybe the best would be to change SRC_URI in sci-biology/exonerate
DEPEND="
	!sci-biology/exonerate
	dev-libs/glib:2"
RDEPEND="${DEPEND}"

src_prepare() {
	tc-export CC
	sed \
		-e 's: -O3 -finline-functions::g' \
		-i configure.in || die
	# we patch the configure.in file like sci-biology/exonerate:gentoo does, though it is ugly hack
	# mv configure.in configure.ac
	default
}

src_configure() {
	econf \
		$(use_enable utils utilities) \
		$(use_enable threads pthreads) \
		--enable-largefile \
		--enable-glib2
}

src_install() {
	default
	doman doc/man/man1/*.1
}
