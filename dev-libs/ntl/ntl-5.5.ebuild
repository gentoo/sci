# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils

DESCRIPTION="A high-performance, portable C++ Library for doing Number Theory"
HOMEPAGE="http://shoup.net/ntl/"
SRC_URI="http://www.shoup.net/ntl/${P}.tar.gz"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc64"
IUSE="doc gmp"

RDEPEND=">=dev-libs/gmp-4.1-r1"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd "${S}"

# Patch to enable compatibility with singular
	epatch "$FILESDIR/${P}-singular.patch"
# Patch to implement a call back framework ( submitted upstream)
	epatch "$FILESDIR/${P}-sage-tools.patch"
# Patch to sanitize the makefile and allow the building of shared library.
# Includes an auxiliary file "linux.mk"
	epatch "$FILESDIR/${P}-shared.patch"
	cp "$FILESDIR/linux.mk" "${S}/src/linux.mk"
}

src_compile() {
	local myconf=""

	use gmp && myconf="${myconf} NTL_GMP_LIP=on"

	cd "${S}/src"
	perl DoConfig \
		PREFIX=/usr \
		${myconf} \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		NTL_STD_CXX=on SHMAKE=linux \
		|| die "DoConfig failed"

	emake || die "emake failed"

	emake shared || die "emake shared failed"
}

src_install() {
	newlib.a src/ntl.a libntl.a || die "installation of static library failed"
	dolib.so src/lib*.so || die "installation of shared library failed"

	insinto /usr/include
	doins -r include/NTL || die "installation of the headers failed"

	dodoc README

	if use doc ; then
		dodoc doc/*.txt
		dohtml doc/*.{html,gif}
	fi
}

src_test() {
	cd src
	emake check || die "emake check failed"
}

pkg_postinst() {
	elog "This version of the ntl ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=221771"
}
