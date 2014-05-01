# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOMAKE=1.11

inherit autotools-utils toolchain-funcs eutils multilib

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="https://github.com/cburstedde/p4est/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2+"
SLOT="0"

IUSE="debug doc examples mpi romio static-libs +vtk-binary"
REQUIRED_USE="romio? ( mpi )"

RDEPEND="
    sci-libs/libsc
	dev-lang/lua
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio?] )"

DEPEND="
    ${RDEPEND}
    virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

PATCHES=( "${FILESDIR}/${P}-add_missing_autotools_files.patch" )

AT_M4DIR="${WORKDIR}/${P}/config ${WORKDIR}/${P}/sc/config"
AUTOTOOLS_AUTORECONF=true

src_prepare() {
	# Use libtool's -release option so that we end up with a valid SONAME
	# and library version symlinks:
	sed -i \
		"s/^\(src_libp4est_la_CPPFLAGS.*\)\$/\1\nsrc_libp4est_la_LDFLAGS = -release ${PV}/" \
		"${S}"/src/Makefile.am || die "sed failed"

	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version

	autotools-utils_src_prepare
}

src_configure() {
	# Manually inject libsc.
	# Somehow --with-sc=$EPREFIX/usr does not work...
	LDFLAGS="${LDFLAGS} -lsc"

	local myeconfargs=(
        $(use_enable debug)
		$(use_enable mpi)
		$(use_enable romio mpiio)
		$(use_enable vtk-binary)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		--without-sc
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

	# Fix up some wrong installation paths:
	dodir /usr/share/p4est
	mv "${ED}"/usr/share/data "${ED}"/usr/share/p4est/data
	mv "${ED}"/etc/* "${ED}"/usr/share/p4est
	rmdir "${ED}"/etc/
}
