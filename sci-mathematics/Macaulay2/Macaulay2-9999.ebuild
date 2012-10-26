# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools elisp-common eutils flag-o-matic python subversion

IUSE="debug emacs optimization"

ESVN_REPO_URI="svn://svn.macaulay2.com/Macaulay2/trunk/M2"

# Those packages will be built internally.
FACTORY="factory-3-1-4-1"
LIBFAC="libfac-3-1-4"

DESCRIPTION="Research tool for commutative algebra and algebraic geometry"
HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"
SRC_BASE="http://www.math.uiuc.edu/${PN}/Downloads/"
SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/${LIBFAC}.tar.gz
		 ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/factory-gftables.tar.gz
		 http://www.math.uiuc.edu/Macaulay2/Downloads/OtherSourceCode/trunk/${FACTORY}.tar.gz
		 http://www.math.uiuc.edu/Macaulay2/Downloads/OtherSourceCode/trunk/mpfr-3.0.1.tar.gz
		 http://www.math.uiuc.edu/Macaulay2/Extra/gtest-1.6.0.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

# Macaulay2 is broken with >=mpfr-3.1, to not force a downgrade on users
# we let it built an internal copy :(
# This dep was removed:
# >=dev-libs/mpfr-3.0.0

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
	>=sci-libs/mpir-2.1.1[cxx]
	sci-libs/cdd+
	sci-libs/cddlib
	sci-libs/lrslib[gmp]
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	sys-process/time
	>=dev-libs/boehm-gc-7.2_alpha6[threads]
	dev-libs/libatomic_ops
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/${PN}-${PV}"

RESTRICT="mirror"

pkg_setup () {
		tc-export CC CPP CXX
		append-cppflags "-I/usr/include/frobby"
		# gtest needs python:2
		python_set_active_version 2
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
	# Macaulay2 developers want that gtest is built internally because
	# the documentation says it may fail if build with options not the
	# same as the tested program.
	cp "${DISTDIR}/gtest-1.6.0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	# Temporary internal build of mpfr-3.0:
	cp "${DISTDIR}/mpfr-3.0.1.tar.gz" "${S}/BUILD/tarfiles/" \
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
		$(use_enable debug) \
		--enable-build-libraries="factory libfac mpfr" \
		--with-unbuilt-programs="4ti2 gfan normaliz nauty cddplus lrslib" \
		|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build not supported yet
	emake -j1
	# For trunk builds we may wish to ignore example errors
	# emake IgnoreExampleErrors=true -j1

	if use emacs; then
		cd "${S}/Macaulay2/emacs"
		elisp-compile *.el
	fi
}

src_test() {
	# No parallel tests yet & Need to increase the time
	# limit for long running tests in Schubert2 to pass
	emake TLIMIT=550 -j1 check
}

src_install () {
	# Parallel install not supported yet
	emake -j1 install

	# Remove emacs files and install them in the
	# correct place if use emacs
	rm -rf "${D}"/usr/share/emacs/site-lisp
	if use emacs; then
		cd "${S}/Macaulay2/emacs"
		elisp-install ${PN} *.elc *.el
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
