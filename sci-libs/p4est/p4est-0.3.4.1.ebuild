# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOMAKE=1.11

inherit autotools-utils toolchain-funcs eutils multilib

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="http://burstedde.ins.uni-bonn.de/release/p4est-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2+"
SLOT="0"

IUSE="debug doc examples mpi romio static-libs"
REQUIRED_USE="romio? ( mpi )"

RDEPEND="
	dev-lang/lua
	sys-apps/util-linux
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio?] )"

DEPEND="
    ${RDEPEND}
    virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog NEWS README)

PATCHES=( "${FILESDIR}/${PN}-libtool-fix.patch" )
AUTOTOOLS_AUTORECONF=true

src_configure() {
	local myeconfargs=(
        $(use_enable debug)
		$(use_enable mpi)
		$(use_enable romio mpiio)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use doc && dodoc -r doc/*

	if use examples
	then
		docinto examples
		dodoc -r example/*
		docompress -x /usr/share/doc/${PF}/examples
	else
		# Remove the compiled example binaries in case of -examples:
		rm -r "${ED}"/usr/bin || die "rm failed"
	fi

	# Fix up some wrong installation pathes:
	dodir /usr/share/p4est
	mv "${ED}"/usr/share/data "${ED}"/usr/share/p4est/data
	mv "${ED}"/etc/* "${ED}"/usr/share/p4est
	rmdir "${ED}"/etc/
}
