# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOMAKE="1.11"

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

DOCS=(AUTHORS ChangeLog COPYING NEWS README)

src_configure() {
	local myeconfargs=(
        $(use_enable debug)
		--enable-shared
		$(use_enable static-libs static)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use doc
	then
		cp -r "${S}"/doc/* "${D}${EPREFIX}"/usr/share/doc/${PF}/
	fi

	if use examples
	then
		mkdir -p "${D}${EPREFIX}"/usr/share/${PN}/examples
		cp -r "${S}"/example/* "${D}${EPREFIX}"/usr/share/${PN}/examples
	else
		# Remove the compiled example binaries in case of -examples:
		rm -r "${D}${EPREFIX}"/usr/bin
	fi

	if ! use static-libs
	then
		# *sigh* The build system apparently ignores --enable/disable-static
		rm "${D}${EPREFIX}"/$(get_libdir)/*.a
	fi

	# Fix up some wrong installation pathes:
	mkdir -p "${D}${EPREFIX}"/usr/share/p4est
	mv "${D}${EPREFIX}"/usr/share/data "${D}${EPREFIX}"/usr/share/p4est/data
	mv "${D}${EPREFIX}"/etc/* "${D}${EPREFIX}"/usr/share/p4est
	rmdir "${D}${EPREFIX}"/etc/
}

