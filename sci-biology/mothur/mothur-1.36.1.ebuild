# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="http://www.mothur.org/"
SRC_URI="https://github.com/mothur/mothur/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi readline zlib"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-libs/boost"
RDEPEND="
	readline? ( sys-libs/readline:= )
	sci-biology/uchime
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	app-arch/unzip"

pkg_setup() {
	fortran-2_pkg_setup
	use mpi && export CXX=mpicxx || export CXX=$(tc-getCXX)
	use amd64 && append-cppflags -DBIT_VERSION
	use readline && export USEREADLINE=yes || export USEREADLINE=no
	export USEBOOST=yes
	use zlib && export USECOMPRESSION=yes || export USECOMPRESSION=no
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
#		"${FILESDIR}"/${PN}-1.27.0-overflows.patch
}

src_compile() {
	# USEBOOST should be set already in pkg_setup
	emake USEMPI=$(usex mpi) USEREADLINE=$(usex readline) USECOMPRESSION=$(usex zlib)
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
