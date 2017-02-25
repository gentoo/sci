# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools elisp-common eutils flag-o-matic git-r3 python-single-r1 toolchain-funcs

FACTORY="factory-4.0.0+m4"
FACTORY_GFTABLES="factory.4.0.1-gftables"

DESCRIPTION="Research tool for commutative algebra and algebraic geometry"
HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"
BASE_URI="http://www.math.uiuc.edu/Macaulay2/Downloads/OtherSourceCode/trunk"
SRC_URI="
	${BASE_URI}/${FACTORY}.tar.gz
	${BASE_URI}/${FACTORY_GFTABLES}.tar.gz
	${BASE_URI}/gtest-1.7.0.tar.gz"
EGIT_REPO_URI="git://github.com/Macaulay2/M2.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="debug emacs +optimization"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	sys-process/time
	virtual/pkgconfig
	app-arch/unzip
	app-text/dos2unix"
# Unzip and dos2unix just for normaliz

RDEPEND="${PYTHON_DEPS}
	sys-libs/gdbm
	dev-libs/ntl
	sci-mathematics/pari[gmp]
	>=sys-libs/readline-6.1
	dev-libs/libxml2:2
	sci-mathematics/flint[gc]
	sci-mathematics/frobby
	sci-mathematics/4ti2
	sci-mathematics/nauty
	>=sci-mathematics/normaliz-2.8
	sci-mathematics/gfan
	sci-libs/mpir[cxx]
	dev-libs/mpfr
	sci-libs/cdd+
	sci-libs/cddlib
	sci-libs/lrslib[gmp]
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	>=dev-libs/boehm-gc-7.2_alpha6[threads]
	dev-libs/libatomic_ops
	emacs? ( virtual/emacs )"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/${PN}-${PV}/"

RESTRICT="mirror"

src_unpack (){
	# unpack "Normaliz2.8.zip"
	git-r3_src_unpack
	# Undo one level of directory until git allows to checkout
	# subdirectories
	mv "${S}"/M2/* "${S}" || die
	# Need to get rid of this now because install wants this location later
	rm -r "${S}/M2" || die
}

pkg_setup () {
	tc-export CC CPP CXX PKG_CONFIG
	append-cppflags "-I/usr/include/frobby"
	# gtest needs python:2
	python-single-r1_pkg_setup
}

src_prepare() {
	# Put updated Normaliz.m2 in place
	# cp "${WORKDIR}/Normaliz2.8/Macaulay2/Normaliz.m2" \
	# 	"${S}/Macaulay2/packages" || die
	# dos2unix "${S}/Macaulay2/packages/Normaliz.m2" || die

	# Patching .m2 files to look for external programs in
	# /usr/bin
	epatch "${FILESDIR}"/${PV}-paths-of-external-programs.patch

	# Shortcircuit lapack tests
	epatch "${FILESDIR}"/${PV}-lapack.patch

	# Factory is a statically linked library which (in this flavor) are not used by any
	# other program. We build it internally and don't install it.
	cp "${DISTDIR}/${FACTORY}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/${FACTORY_GFTABLES}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	# Macaulay2 developers want that gtest is built internally because
	# the documentation says it may fail if build with options not the
	# same as the tested program.
	cp "${DISTDIR}/gtest-1.7.0.tar.gz" "${S}/BUILD/tarfiles/" \
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
	./configure LIBS="$($(tc-getPKG_CONFIG) --libs lapack)" \
		--prefix="${D}/usr" \
		--disable-encap \
		--disable-strip \
		--with-issue=Gentoo \
		$(use_enable optimization optimize) \
		$(use_enable debug) \
		--enable-build-libraries="factory" \
		--with-unbuilt-programs="4ti2 gfan normaliz nauty cddplus lrslib" \
		|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build not supported yet
	# emake -j1
	# For trunk builds we may wish to ignore example errors
	emake IgnoreExampleErrors=true -j1

	if use emacs; then
		cd "${S}/Macaulay2/emacs" || die
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
	# NumericalAlgebraicGeometry fails (during install too?)
	emake IgnoreExampleErrors=true -j1 install

	# Remove emacs files and install them in the
	# correct place if use emacs
	rm -rf "${ED}"/usr/share/emacs/site-lisp || die
	if use emacs; then
		cd "${S}/Macaulay2/emacs" || die
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
