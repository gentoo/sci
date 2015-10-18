# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOMAKE=1.11

inherit autotools-utils toolchain-funcs eutils multilib

DESCRIPTION="Support for parallel scientific applications"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="https://github.com/cburstedde/libsc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples mpi romio static-libs"

REQUIRED_USE="romio? ( mpi )"

RDEPEND="
	dev-lang/lua:*
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio?] )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS NEWS README)

AUTOTOOLS_AUTORECONF=true

src_prepare() {
	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version

	autotools-utils_src_prepare
}

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

	if use examples; then
		docinto examples
		dodoc -r example/*
		docompress -x /usr/share/doc/${PF}/examples
	else
		# Remove the compiled example binaries in case of -examples:
		rm -r "${ED}"/usr/bin || die "rm failed"
	fi

	# Fix up some wrong installation paths:
	dodir /usr/share/libsc
	mv "${ED}"/etc/* "${ED}"/usr/share/libsc
	rmdir "${ED}"/etc/
}
