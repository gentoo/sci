# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools elisp-common eutils

IUSE="emacs optimization"

MY_REV="r10737"
DESCRIPTION="research tool for commutative algebra and algebraic geometry"
SRC_BASE="http://www.math.uiuc.edu/${PN}/Downloads/"
SRC_URI="${SRC_BASE}/SourceCode/Macaulay2-${PV}-${MY_REV}.bz2 -> ${P}.tar.bz2
		 ${SRC_BASE}/OtherSourceCode/1.3/factory-3-1-0.tar.gz
		 ${SRC_BASE}/OtherSourceCode/1.3/libfac-3-1-0.tar.gz"

HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/gdbm
	>=dev-libs/ntl-5.5.2
	>=dev-libs/boehm-gc-7.1
	>=sci-mathematics/pari-2.3.4[gmp]
	>=sys-libs/readline-6.0
	dev-libs/libxml2
	sci-mathematics/frobby
	sci-mathematics/4ti2
	sci-mathematics/normaliz
	sci-mathematics/gfan
	>=dev-libs/mpfr-2.4.1
	>=sci-libs/mpir-1.3.1[cxx]
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	sys-process/time
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/${PN}-${PV}-${MY_REV}"

RESTRICT="mirror"

pkg_setup () {
		tc-export CC CPP CXX
}

src_prepare() {
	# Patching .m2 files to look for external programs in
	# /usr/bin
	epatch "${FILESDIR}"/paths-of-dependencies.patch

	if ! use optimization ; then
		epatch "${FILESDIR}"/respect-CFLAGS.patch
	fi

	# Fixing make warnings about unavailable jobserver:
	sed -i "s/\$(MAKE)/+ \$(MAKE)/g" "${S}"/distributions/Makefile.in

	# Factory and libfac are statically linked libraries which (in this flavor)
	# are not used by any other program. We build them internally and don't install them
	# Permission was granted to tomka by bicatali on IRC.
	mkdir "${S}/BUILD/tarfiles" || die "Creation of directory failed"
	cp "${DISTDIR}/factory-3-1-0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/libfac-3-1-0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"

	eautoreconf
}

src_configure (){

	# Recommended in bug #268064 Possibly unecessary
	# but should not hurt anybody.
	if ! use emacs; then
		tags="ctags"
	fi

	CPPFLAGS="-I/usr/include/frobby" \
		./configure --prefix="${D}/usr" \
		--disable-encap \
		--disable-strip \
		--enable-build-libraries="factory libfac" \
		--with-unbuilt-programs="4ti2 gfan normaliz" \
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
	emake check || die "tests failed"
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
