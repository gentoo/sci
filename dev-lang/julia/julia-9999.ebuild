# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/JuliaLang/julia.git"

inherit git-2 elisp-common eutils multilib

DESCRIPTION="The Julia Language: a fresh approach to technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs"

RDEPEND=">=sys-devel/llvm-3.0
	sys-libs/readline
	emacs? ( !app-emacs/ess )
	>=sci-libs/suitesparse-4.0
	sci-libs/arpack
	sci-libs/fftw
	dev-libs/gmp
	>=dev-libs/double-conversion-1.1.1
	>=sys-libs/libunwind-1.1
	dev-libs/libpcre
	sci-mathematics/glpk
	sys-libs/zlib
	virtual/blas
	virtual/lapack"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/julia-nopatchelf.patch"
	# Folder /usr/include/suitesparse does not exists, everything should be in /usr/include
	sed -e "s|SUITESPARSE_INC = -I /usr/include/suitesparse|SUITESPARSE_INC = |g" \
	-i deps/Makefile

	blasname=$($(tc-getPKG_CONFIG) --libs blas | \
		sed -e "s/-l\([a-z0-9]*\).*/lib\1/")
	lapackname=$($(tc-getPKG_CONFIG) --libs lapack | \
		sed -e "s/-l\([a-z0-9]*\).*/lib\1/")

	sed -i \
			-e 's|\(USE_SYSTEM_.*\)=.*|\1=1|g' \
			-e "s|-lblas|$($(tc-getPKG_CONFIG) --libs blas)|" \
			-e "s|-llapack|$($(tc-getPKG_CONFIG) --libs lapack)|" \
			-e "s|liblapack|${lapackname}|" \
			-e "s|libblas|${blasname}|" Make.inc || die

	# do not set the RPATH	
	sed -e "/RPATH = /d" -e "/RPATH_ORIGIN = /d" -i Make.inc
}

src_compile() {
	emake
	use doc && emake -C doc html
	use emacs && elisp-compile contrib/julia-mode.el
}

src_install() {
	emake install PREFIX="${D}/usr"
	cat > 99julia <<-EOF
		LDPATH=/usr/$(get_libdir)/julia
	EOF
	doenvd 99julia

	if use emacs; then
		elisp-install "${PN}" contrib/julia-mode.el
		elisp-site-file-install "${FILESDIR}"/63julia-gentoo.el
	fi
	use doc && dohtml -r doc/_build/html/
	dodoc README.md
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

src_test() {
	emake -C test || die "Running tests failed"
}
