# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WANT_AUTOMAKE=1.11

inherit autotools-utils toolchain-funcs eutils multilib

DESCRIPTION="Support for parallel scientific applications"
HOMEPAGE="http://www.p4est.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/cburstedde/libsc.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/cburstedde/libsc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="debug examples mpi openmp romio static-libs threads"

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

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && use openmp; then
		tc-has-openmp || \
			die "Please select an openmp capable compiler like gcc[openmp]"
	fi
}

src_prepare() {
	# Inject a version number into the build system
	echo "${PV}" > ${S}/.tarball-version

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable mpi)
		$(use_enable openmp openmp)
		$(use_enable romio mpiio)
		$(use_enable threads pthread)
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
	mv "${ED}"/etc/* "${ED}"/usr/share/libsc || die "mv failed"
	rmdir "${ED}"/etc/ || die "rmdir failed"
	mv "${ED}"/usr/share/ini/* "${ED}"/usr/share/libsc || die "mv failed"
	rmdir "${ED}"/usr/share/ini || die "rmdir failed"
}
