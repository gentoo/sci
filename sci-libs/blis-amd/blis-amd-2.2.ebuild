# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit fortran-2 python-any-r1

DESCRIPTION="AMD optimized BLAS-like Library Instantiation Software Framework"
HOMEPAGE="https://developer.amd.com/amd-aocl/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/amd/blis"
else
	SRC_URI="https://github.com/amd/blis/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/blis-"${PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="64bit-index doc eselect-ldso openmp pthread static-libs"
REQUIRED_USE="?? ( openmp pthread ) ?? ( eselect-ldso 64bit-index )"

RDEPEND+="
	>=app-eselect/eselect-blas-0.2
	!sci-libs/blis
"
DEPEND+="${RDEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}"/${P}-blas_rpath.patch
)

pkg_pretend() {
	elog "It is very important that you set the BLIS_CONFNAME"
	elog "variable when compiling blis as it tunes the"
	elog "compilation to the specific CPU architecture."
	elog "To look at valid BLIS_CONFNAMEs, look at directories in"
	elog "\t https://github.com/amd/blis/tree/master/config"
	elog "At the very least, it should be set to the ARCH of"
	elog "the machine this will be run on, which gives a"
	elog "performance increase of ~4-5x."
}

src_configure() {
	local myconf=(
		--prefix="${BROOT}"/usr
		--libdir="${BROOT}"/usr/$(get_libdir)
		--enable-cblas
		--enable-blas
		--enable-arg-max-hack
		--enable-verbose-make
		--without-memkind
		--enable-shared
		$(use_enable static-libs static)
	)

	use 64bit-index && \
	myconf+=(
		--int-size=64
		--blas-int-size=64
	)

	# threading backend - openmp/pthreads/no
	if use openmp; then
		myconf+=( --enable-threading=openmp )
	elif use pthread; then
		myconf+=( --enable-threading=pthreads )
	else
		myconf+=( --enable-threading=no )
	fi

	# not an autotools configure script
	./configure "${myconf[@]}" \
			"${EXTRA_ECONF[@]}" \
			${BLIS_CONFNAME:-generic} || die
}

src_compile() {
	SET_RPATH=no \
	DEB_LIBBLAS=libblas.so.3 \
	DEB_LIBCBLAS=libcblas.so.3 \
	default
}

src_test() {
	emake check
}

src_install() {
	default
	use doc && dodoc README.md docs/*.md

	use eselect-ldso || return

	insinto /usr/$(get_libdir)/blas/blis-amd
	doins lib/${BLIS_CONFNAME:-generic}/lib{c,}blas.so.3
	dosym libblas.so.3 usr/$(get_libdir)/blas/blis-amd/libblas.so
	dosym libcblas.so.3 usr/$(get_libdir)/blas/blis-amd/libcblas.so
}

pkg_postinst() {
	use eselect-ldso || return

	local libdir=$(get_libdir) me="blis-amd"

	# check blas
	elog "adding ${me}"
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	elog "added ${me}"
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == "${me}" || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect blas validate
}
