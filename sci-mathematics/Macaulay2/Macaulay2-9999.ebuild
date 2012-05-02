# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools elisp-common eutils flag-o-matic subversion

IUSE="emacs optimization"

ESVN_REPO_URI="svn://svn.macaulay2.com/Macaulay2/trunk/M2"

BOEHM_GC="gc-7.3alpha1.2012.01.23"
FACTORY="factory-3-1-4-1"
LIBFAC="libfac-3-1-4"

DESCRIPTION="Research tool for commutative algebra and algebraic geometry"
HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"
SRC_BASE="http://www.math.uiuc.edu/${PN}/Downloads/"
SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/${LIBFAC}.tar.gz
		 ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/factory-gftables.tar.gz
		 http://www.math.uiuc.edu/Macaulay2/Downloads/OtherSourceCode/trunk/${FACTORY}.tar.gz
		 http://www.math.uiuc.edu/Macaulay2/Extra/${BOEHM_GC}.tar.gz"
# Somebody changed the tarball after release... grrr.
#		 ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/${FACTORY}.tar.gz

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

DEPEND="
	sys-libs/gdbm
	>=dev-libs/ntl-5.5.2
	>=sci-mathematics/pari-2.3.4[gmp]
	>=sys-libs/readline-6.1
	dev-libs/libxml2:2
	sci-mathematics/frobby
	sci-mathematics/4ti2
	sci-mathematics/nauty
	>=sci-mathematics/normaliz-2.7
	sci-mathematics/gfan
	>=dev-libs/mpfr-3.0.0
	>=sci-libs/mpir-2.1.1[cxx]
	sci-libs/cdd+
	sci-libs/cddlib
	sci-libs/lrslib[gmp]
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	sys-process/time
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/${PN}-${PV}"

RESTRICT="mirror"

pkg_setup () {
		tc-export CC CPP CXX
		append-cppflags "-I/usr/include/frobby"
}

src_prepare() {
	# Patching .m2 files to look for external programs in
	# /usr/bin
	epatch "${FILESDIR}"/${PV}-paths-of-external-programs.patch

	# Fixing make warnings about unavailable jobserver:
	sed -i "s/\$(MAKE)/+ \$(MAKE)/g" "${S}"/distributions/Makefile.in

	# Factory, and libfac are statically linked libraries which (in this flavor) are not used by any
	# other program. We build them internally and don't install them
	mkdir "${S}/BUILD/tarfiles" || die "Creation of directory failed"
	cp "${DISTDIR}/${FACTORY}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/factory-gftables.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/${LIBFAC}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	# Macaulay 2 insists on a snapshot of boehm-gc that is not available elsewhere
	# We will let it build its internal version for now.  Note:
	# The resulting QA warning is known.
	cp "${DISTDIR}/${BOEHM_GC}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"

	eautoreconf
}

src_configure (){
	# Recommended in bug #268064 Possibly unecessary
	# but should not hurt anybody.
	if ! use emacs; then
		tags="ctags"
	fi

	# configure instead of econf to enable install with --prefix
	./configure --prefix="${D}/usr" \
		--disable-encap \
		--disable-strip \
		$(use_enable optimization optimize) \
		--enable-build-libraries="factory gc libfac" \
		--with-unbuilt-programs="4ti2 gfan normaliz nauty cddplus lrslib" \
		|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build not supported yet
	emake -j1 || die "failed to build Macaulay"

	if use emacs; then
		cd "${S}/Macaulay2/emacs"
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

src_test() {
	# No parallel tests yet & Need to increase the time
	# limit for long running tests in Schubert2 to pass
	emake TLIMIT=550 -j1 check || die "tests failed"
}

src_install () {
	# Parallel install not supported yet
	emake -j1 install || die "install failed"

	# Remove emacs files and install them in the
	# correct place if use emacs
	rm -rf "${D}"/usr/share/emacs/site-lisp
	if use emacs; then
		cd "${S}/Macaulay2/emacs"
		elisp-install ${PN} *.elc *.el || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "If you want to set a hot key for Macaulay2 in Emacs add a line similar to"
		elog "(global-set-key [ f12 ] 'M2)"
		elog "in order to set it to F12 (or choose a different one)."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
