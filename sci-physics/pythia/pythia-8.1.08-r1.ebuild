# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator multilib toolchain-funcs

MV=$(get_major_version)
MY_P=${PN}$(replace_all_version_separators "" ${PV})

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="http://home.thep.lu.se/~torbjorn/Pythia.html"
SRC_URI="http://home.thep.lu.se/~torbjorn/${PN}${MV}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="8"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	# evil hand-rolled stuff (no autoconf)
	./configure \
		--enable-shared \
		|| die "configure failed"
	# add user's flags TODO can this be done better?
	echo CXXFLAGS+="${CXXFLAGS}" >> config.mk
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_test() {
	cd "${S}"/examples
	./configure \
		--enable-shared \
		|| die "configure for examples failed"
	echo CXXFLAGS+=${CXXFLAGS} >> config.mk
	emake CXX=$(tc-getCXX) || die "emake examples failed"
	./runmains || die "test of examples failed"
}

src_install() {
	dolib.so lib/*so || die "shared lib install failed"
	dolib.a lib/archive/* || die "static lib install failed"

	insinto /usr/include/${PN}
	doins include/* || die "headers install failed"

	insinto /usr/share/${PN}
	doins -r xmldoc || die "xmldoc install failed"
	echo PYTHIA8DATA=/usr/share/${PN}/xmldoc >> 99pythia8
	doenvd 99pythia8

	insinto /usr/share/doc/${PF}
	dodoc GUIDELINES AUTHORS README
	if use doc; then
		doins -r worksheet.pdf examples htmldoc || die "doc install failed"
	fi
}

pkg_postinst() {
	elog "pythia-8 ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=231484"
}
