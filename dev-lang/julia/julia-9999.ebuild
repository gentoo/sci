# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 elisp-common eutils multilib pax-utils toolchain-funcs

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/JuliaLang/julia.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc emacs"

RDEPEND="
	dev-lang/R:0=
	dev-libs/double-conversion:0=
	dev-libs/gmp:0=
	dev-libs/libpcre:3=
	dev-libs/mpfr:0=
	dev-libs/utf8proc:0=
	sci-libs/arpack:0=
	sci-libs/camd:0=
	sci-libs/cholmod:0=
	sci-libs/fftw:3.0=[threads]
	sci-libs/openlibm:0=
	sci-libs/spqr:0=
	sci-libs/umfpack:0=
	sci-mathematics/glpk:0=
	=sys-devel/llvm-3.3*
	>=sys-libs/libunwind-1.1:7=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	virtual/blas
	virtual/lapack
	emacs? ( app-emacs/ess )"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

src_prepare() {
	# sadlib keep fetching in ebuild to make sure live build works
	# /usr/include/suitesparse is for debian only
	# respect prefix, flags
	sed -i \
		-e 's|^\(SUITESPARSE_INC\s*=\).*||g' \
		-e "s|-O3|${CFLAGS}|g" \
		-e 's|/usr/bin/||g' \
		-e "s|/usr/include|${EPREFIX%/}/usr/include|g" \
		deps/Makefile || die

	sed -i \
		-e "s|\(JULIA_EXECUTABLE = \)\(\$(JULIAHOME)/julia\)|\1 LD_LIBRARY_PATH=\$(BUILD)/$(get_libdir) \2|" \
		-e "s|-O3|${CFLAGS}|g" \
		-e "s|libdir = \$(prefix)/lib|libdir = \$(prefix)/$(get_libdir)|" \
		-e "s|/usr/lib|${EPREFIX}/usr/$(get_libdir)|" \
		-e "s|/usr/include|${EPREFIX}/usr/include|" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|" \
		-e "s|^JULIA_COMMIT = .*|JULIA_COMMIT = v${PV}|" \
		-e '/MARCH = /d' \
		Make.inc || die

	sed -i \
		-e "s|,lib)|,$(get_libdir))|g" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|g" \
		Makefile || die

	sed -i \
		-e "s|ar -rcs|$(tc-getAR) -rcs|g" \
		src/Makefile || die
}

src_configure() {
	# libuv is an incompatible fork from upstream, so don't use system one
	cat <<-EOF > Make.user
		LIBBLAS=$($(tc-getPKG_CONFIG) --libs blas)
		LIBBLASNAME=$($(tc-getPKG_CONFIG) --libs blas | sed -e "s/-l\([a-z0-9]*\).*/lib\1/")
		LIBLAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
		LIBLAPACKNAME=$($(tc-getPKG_CONFIG) --libs lapack | sed -e "s/-l\([a-z0-9]*\).*/lib\1/")
		USE_BLAS64=0
		USE_LLVM_SHLIB=1
		USE_SYSTEM_ARPACK=1
		USE_SYSTEM_BLAS=1
		USE_SYSTEM_FFTW=1
		USE_SYSTEM_GMP=1
		USE_SYSTEM_GRISU=1
		USE_SYSTEM_LAPACK=1
		USE_SYSTEM_LIBM=1
		USE_SYSTEM_LIBUNWIND=1
		USE_SYSTEM_LIBUV=0
		USE_SYSTEM_LLVM=1
		USE_SYSTEM_MPFR=1
		USE_SYSTEM_OPENLIBM=1
		USE_SYSTEM_OPENSPECFUN=0
		USE_SYSTEM_PCRE=1
		USE_SYSTEM_READLINE=1
		USE_SYSTEM_RMATH=1
		USE_SYSTEM_SUITESPARSE=1
		USE_SYSTEM_UTF8PROC=1
		USE_SYSTEM_ZLIB=1
		VERBOSE=1
	EOF
	emake -j1 cleanall
	if [[ $(get_libdir) != lib ]]; then
		mkdir -p usr/$(get_libdir) || die
		ln -s $(get_libdir) usr/lib || die
	fi
}

src_compile() {
	emake -j1 julia-release
	pax-mark m $(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')
	emake -j1
	use doc && emake -C doc html
	use emacs && elisp-compile contrib/julia-mode.el
}

src_test() {
	emake test
}

src_install() {
	emake install prefix="${ED}/usr"
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
