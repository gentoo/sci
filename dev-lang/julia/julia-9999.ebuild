# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 elisp-common eutils multilib pax-utils toolchain-funcs

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/JuliaLang/julia.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc emacs int64"

RDEPEND="
	dev-lang/R:0=
	dev-libs/double-conversion:0=
	dev-libs/gmp:0=
	dev-libs/libpcre:3=
	>=dev-libs/libgit2-0.21
	dev-libs/mpfr:0=
	dev-libs/utf8proc:0=
	sci-libs/arpack:0=
	sci-libs/camd:0=
	sci-libs/cholmod:0=
	sci-libs/fdlibm:0=
	sci-libs/fftw:3.0=[threads]
	sci-libs/openlibm:0=
	sci-libs/spqr:0=
	sci-libs/umfpack:0=
	sci-mathematics/glpk:0=
	>=sys-devel/llvm-3.4
	>=sys-libs/libunwind-1.1:7=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	>=virtual/blas-2.1-r2[int64?]
	>=virtual/lapack-3.5-r2[int64?]
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

	local blasprofname=$(usex int64 "blas-int64" "blas")
	local lapackprofname=$(usex int64 "lapack-int64" "lapack")
	local blasname=$($(tc-getPKG_CONFIG) --libs-only-l "${blasprofname}" | \
		sed -e "s/-l\([^ \t]*\).*/lib\1/")
	local lapackname=$($(tc-getPKG_CONFIG) --libs-only-l "${lapackprofname}" | \
		sed -e "s/-l\([^ \t]*\).*/lib\1/")
	sed -i \
		-e "s|-O3|${CFLAGS}|g" \
		-e "s|libdir = \$(prefix)/lib|libdir = \$(prefix)/$(get_libdir)|" \
		-e "s|build_libdir = \$(build_prefix)/lib|build_libdir = \$(build_prefix)/$(get_libdir)|" \
		-e "s|build_private_libdir = \$(build_prefix)/lib/julia|build_private_libdir = \$(build_prefix)/$(get_libdir)/julia|" \
		-e "s|/usr/lib|${EPREFIX}/usr/$(get_libdir)|" \
		-e "s|/usr/include|${EPREFIX}/usr/include|" \
		-e "s|^JULIA_COMMIT = .*|JULIA_COMMIT = v${PV}|" \
		-e "s|-lblas|$($(tc-getPKG_CONFIG) --libs-only-l ${blasprofname})|" \
		-e "s|-llapack|$($(tc-getPKG_CONFIG) --libs-only-l ${lapackprofname})|" \
		-e "s|liblapack|${lapackname}|g" \
		-e "s|libblas|${blasname}|g" \
		-e "s|-O3|${CFLAGS}|g" \
		-e "s|JCFLAGS = |JCFLAGS = $($(tc-getPKG_CONFIG) --cflags "${lapackprofname}") ${CFLAGS} |g" \
		-e "s|JCXXCFLAGS = |JCXXFLAGS = $($(tc-getPKG_CONFIG) --cflags "${lapackprofname}") ${CXXFLAGS} |g" \
		-e "s|JFFLAGS = |JFFLAGS = ${FFLAGS} |g" \
		-e '/MARCH = /d' \
		Make.inc || die

	sed -i \
		-e "s|,lib)|,$(get_libdir))|g" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|g" \
		-e "s|\$(JL_LIBDIR),lib|\$(JL_LIBDIR),$(get_libdir)|" \
		-e "s|\$(JL_PRIVATE_LIBDIR),lib|\$(JL_PRIVATE_LIBDIR),$(get_libdir)|" \
		Makefile || die

	sed -i \
		-e "s|ar -rcs|$(tc-getAR) -rcs|g" \
		-e "s|LLVMLINK = -lLLVM-\$(LLVM_VER)|LLVMLINK = $(llvm-config --libs) $(llvm-config --ldflags)|" \
		src/Makefile || die

	sed -e "s|libopenblas|${blasname}|g" \
		-i base/util.jl \
		-i test/perf/micro/Makefile || die

	# Occasional test suite failure due to ARPACK #6162 https://github.com/JuliaLang/julia/issues/6162
	sed -e 's|"arpack", ||' \
		-i test/runtests.jl || die
}

src_configure() {
	# libuv is an incompatible fork from upstream, so don't use system one
	local blasprofname=$(usex int64 "blas-int64" "blas")
	local lapackprofname=$(usex int64 "lapack-int64" "lapack")
	cat <<-EOF > Make.user
		LIBBLAS=$($(tc-getPKG_CONFIG) --libs ${blasprofname})
		LIBBLASNAME=$($(tc-getPKG_CONFIG) --libs-only-l ${blasprofname} | sed -e "s/-l\([a-z0-9_]*\).*/lib\1/")
		LIBLAPACK=$($(tc-getPKG_CONFIG) --libs-only-l ${lapackprofname})
		LIBLAPACKNAME=$($(tc-getPKG_CONFIG) --libs-only-l ${lapackprofname} | sed -e "s/-l\([a-z0-9_]*\).*/lib\1/")
		LIBM=-lfdlibm
		LIBMNAME=libfdlibm
		USE_BLAS64=$(usex int64 "1" "0")
		USE_LLVM_SHLIB=1
		USE_SYSTEM_ARPACK=1
		USE_SYSTEM_BLAS=1
		USE_SYSTEM_FFTW=1
		USE_SYSTEM_GMP=1
		USE_SYSTEM_GRISU=1
		USE_SYSTEM_LAPACK=1
		USE_SYSTEM_LIBGIT2=1
		USE_SYSTEM_LIBM=0
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
	emake julia-release
	pax-mark m $(file usr/bin/julia* | awk -F : '/ELF/ {print $1}')
	default
	use doc && emake -C doc html
	use emacs && elisp-compile contrib/julia-mode.el
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
