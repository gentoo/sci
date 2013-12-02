# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/JuliaLang/julia.git"
EGIT_HAS_SUBMODULES=yes

inherit git-2 elisp-common eutils multilib

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc emacs"

RDEPEND="
	dev-libs/double-conversion
	dev-libs/gmp
	dev-libs/libpcre
	dev-util/patchelf
	sci-libs/arpack
	sci-libs/fftw
	sci-libs/openlibm
	>=sci-libs/suitesparse-4.0
	sci-mathematics/glpk
	>=sys-devel/llvm-3.0
	>=sys-libs/libunwind-1.1
	sys-libs/readline
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	emacs? ( !app-emacs/ess )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# /usr/include/suitesparse is for debian only
	# respect prefix, flags
	sed -i \
		-e 's|^\(SUITESPARSE_INC\s*=\).*||g' \
		-e 's|/usr/bin/||g' \
		-e "s|/usr/include|${EROOT%/}/usr/include|g" \
		-e "s|-O3|${CFLAGS}|g" \
		deps/Makefile || die

	# mangle Make.inc for system libraries
	# do not set the RPATH
	local blasname=$($(tc-getPKG_CONFIG) --libs blas | \
		sed -e "s/-l\([a-z0-9]*\).*/lib\1/")
	local lapackname=$($(tc-getPKG_CONFIG) --libs lapack | \
		sed -e "s/-l\([a-z0-9]*\).*/lib\1/")

	sed -i \
		-e 's|\(USE_QUIET\s*\)=.*|\1=0|g' \
		-e 's|\(USE_SYSTEM_.*\)=.*|\1=1|g' \
		-e 's|\(USE_SYSTEM_LIBUV\)=.*|\1=0|g' \
		-e 's|\(USE_SYSTEM_LIBM\)=.*|\1=0|g' \
		-e "s|-lblas|$($(tc-getPKG_CONFIG) --libs blas)|" \
		-e "s|-llapack|$($(tc-getPKG_CONFIG) --libs lapack)|" \
		-e "s|liblapack|${lapackname}|" \
		-e "s|libblas|${blasname}|" \
		-e 's|\(JULIA_EXECUTABLE = \)\($(JULIAHOME)/julia\)|\1 LD_LIBRARY_PATH=$(BUILD)/lib \2|' \
		-e "s|-O3|${CFLAGS}|g" \
		Make.inc || die
}

src_compile() {
	emake cleanall
	emake
	use doc && emake -C doc html
	use emacs && elisp-compile contrib/julia-mode.el
}

src_test() {
	emake test
}

src_install() {
	emake install PREFIX="${D}/usr"
	cat > 99julia <<-EOF
		LDPATH=${EROOT%/}/usr/$(get_libdir)/julia
	EOF
	doenvd 99julia

	if use emacs; then
		elisp-install "${PN}" contrib/julia-mode.el
		elisp-site-file-install "${FILESDIR}"/63julia-gentoo.el
	fi
	use doc && dohtml -r doc/_build/html/*
	dodoc README.md
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
