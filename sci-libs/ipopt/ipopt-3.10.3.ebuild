# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib toolchain-funcs

MYPN=Ipopt

DESCRIPTION="Interior-Point Optimizer for large-scale nonlinear optimization"
HOMEPAGE="https://projects.coin-or.org/Ipopt/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples lapack mumps static-libs test"

RDEPEND="
	virtual/blas
	lapack? ( virtual/lapack )
	mumps? ( sci-libs/mumps )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libipopt_la_LIBADD.*=.*\)$:\1 @IPOPTLIB_LIBS@:g' \
		src/Interfaces/Makefile.in || die

	if has_version sci-libs/mumps[-mpi]; then
		ln -s "${EPREFIX}"/usr/include/mpiseq/mpi.h \
			src/Algorithm/LinearSolvers/
	elif has_version sci-libs/mumps[mpi]; then
		export CXX=mpicxx
	fi
}

src_configure() {
	local myeconfargs=(
		--with-blas-lib="$($(tc-getPKG_CONFIG) --libs blas)"
		$(use_with doc dot)
	)
	if use lapack; then
		myeconfargs+=( --with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" )
	else
		myeconfargs+=( --without-lapack )
	fi
	if use mumps; then
		myeconfargs+=(
			--with-mumps-incdir="${EPREFIX}"/usr/include
			--with-mumps-lib="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps" )
	else
		myeconfargs+=( --without-mumps )
	fi
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo doxydoc)
}

src_test() {
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	use doc && HTML_DOC=("${AUTOTOOLS_BUILD_DIR}/doxydocs/html/")
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
