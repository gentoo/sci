# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils toolchain-funcs eutils multilib

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="http://burstedde.ins.uni-bonn.de/release/p4est-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2+"
SLOT="0"

IUSE="debug doc examples mpi static-libs"

DEPEND="
	dev-lang/lua
	sys-apps/util-linux
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi )"

RDEPEND="
    ${DEPEND}
    virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	local myeconfargs=(
        $(use_enable debug)
		$(use_enable mpi)
		$(use_enable mpi mpiio)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use doc && dodoc -r "${S}"/doc/*

	if use examples
	then
		insinto /usr/share/${PN}/examples
		doins -r "${S}"/example/*
	else
		# Remove the compiled example binaries in case of -examples:
		rm -r "${ED}"/usr/bin
	fi

	# *sigh* The build system apparently ignores --disable-static
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a

	# Fix up some wrong installation pathes:
	dodir /usr/share/p4est
	mv "${ED}"/usr/share/data "${ED}"/usr/share/p4est/data
	mv "${ED}"/etc/* "${ED}"/usr/share/p4est
	rmdir "${ED}"/etc/
}
