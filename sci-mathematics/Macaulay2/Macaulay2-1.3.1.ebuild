# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools elisp-common eutils flag-o-matic subversion

# For the time being Upstream does not provide source tarballs,
# but realease branches in their svn

# Todolist:
# Ebuild for gfan
# factory, libfac
# .m2 files patchen

ESVN_REPO_URI="svn://macaulay2.math.uiuc.edu/Macaulay2/release-branches/1.3.1"

IUSE="emacs"

PACKURL="http://www.math.uiuc.edu/Macaulay2/Downloads/OtherSourceCode/1.3/"
DESCRIPTION="research tool for commutative algebra and algebraic geometry"
SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/factory-3-1-0.tar.gz \
	ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/libfac-3-1-0.tar.gz \
	${PACKURL}/frobby_v0.8.2.tar.gz"
#	mirror://gentoo/${P}-src.tar.bz2

HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

# mpir 1.3.0_rc3 does not work!
DEPEND="sys-libs/gdbm
	>=dev-libs/ntl-5.5.2
	>=dev-libs/boehm-gc-7.1
	>=sci-mathematics/pari-2.3.4[gmp]
	>=sys-libs/readline-6.0
	dev-libs/libxml2
	>=sci-mathematics/4ti2-1.3.2
	>=sci-mathematics/normaliz-2.2
	sci-mathematics/gfan
	>=dev-libs/mpfr-2.4.1
	=dev-libs/mpir-1.2.1[-nocxx]
	sys-libs/gdbm
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	sys-process/time
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/1.3.1"

src_unpack() {
	subversion_src_unpack
	# Patching .m2 files to look for external programs in
	# /usr/bin
	cd "${S}"
	epatch "${FILESDIR}/paths-of-dependencies.patch"

	mkdir "${S}/BUILD/tarfiles"
	# Put sourcfile in the right location:
	cp "${DISTDIR}/frobby_v0.8.2.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/factory-3-1-0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/libfac-3-1-0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"

	# Remove the external programs from built list,
	# configure does not check for them
	cd "${S}"
	sed "s/4ti2 gfan normaliz//" -i configure.ac
	eautoreconf

}

src_configure (){

	# Recommended in bug #268064 Possibly unecessary
	# but should not hurt anybody.
	if ! use emacs; then
		tags="ctags"
	fi

	./configure --prefix="${D}/usr" --disable-encap \
		|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build not yet supported
	emake -j1 || die "failed to build Macaulay"
}

src_test() {
	make check || die "tests failed"
}

src_install () {

	make install || die "install failed"

	# nothing useful in here, get rid of it
	# NOTE: Macaulay installs into lib even on amd64 hence don't
	# replace lib with $(get_libdir) below!
	rm -fr "${D}"/usr/lib \
		|| die "failed to remove empty /usr/lib"

	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"
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
