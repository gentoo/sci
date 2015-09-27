# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOMAKE=1.11

inherit autotools-utils toolchain-funcs eutils multilib

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="
	https://github.com/cburstedde/p4est/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/cburstedde/libsc/archive/v${PV}.tar.gz -> libsc-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2+"
SLOT="0"

IUSE="debug doc examples mpi romio static-libs +vtk-binary"
REQUIRED_USE="romio? ( mpi )"

RDEPEND="
	>=sci-libs/libsc-1.0[mpi,romio]
	dev-lang/lua:*
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio?] )"

DEPEND="
	${RDEPEND}
	sys-devel/automake:1.11
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

AT_M4DIR="${WORKDIR}/${P}/config ${WORKDIR}/${P}/sc/config"
AUTOTOOLS_AUTORECONF=true

src_prepare() {
	# Inject libsc to get  all parts of the build system...
	rmdir "${S}/sc" || die "rmdir failed"
	mv "${WORKDIR}/libsc-${PV}" "${S}/sc" || die "mv failed"

	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version

	autotools-utils_src_prepare

	sed -i \
		"s/P4EST_SC_DIR\/etc/P4EST_SC_DIR\/share\/libsc/" \
		"${S}"/configure || die "sed failed"

	sed -i \
		"s/libsc\.la/libsc\.so/" \
		"${S}"/configure || die "sed failed"

}

src_configure() {
	# Somehow --with-sc=$EPREFIX/usr does not work...
	LDFLAGS="${LDFLAGS} -lsc"

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable mpi)
		$(use_enable romio mpiio)
		$(use_enable vtk-binary)
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		--with-sc="${EPREFIX}/usr"
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
