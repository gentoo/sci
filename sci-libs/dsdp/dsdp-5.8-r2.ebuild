# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/dsdp/dsdp-5.8-r1.ebuild,v 1.1 2012/01/17 17:36:56 bicatali Exp $

EAPI=4

inherit eutils toolchain-funcs versionator multilib

MYP=DSDP${PV}

DESCRIPTION="Software for interior-point for semidefinite programming"
HOMEPAGE="http://www.mcs.anl.gov/hs/software/DSDP/"
SRC_URI="http://www.mcs.anl.gov/hs/software/DSDP//${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc examples"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-readsdpa.patch \
		"${FILESDIR}"/${P}-gold.patch \
		"${FILESDIR}"/${P}-sharedmake.patch \
		"${FILESDIR}"/${P}-malloc.patch
	find . -name Makefile -exec \
		sed -i -e 's:make :$(MAKE) :g' '{}' \;

	local sharedlib="-Wl,-soname=lib${PN}$(get_libname $(get_major_version))"
	if [[ ${CHOST} == *-darwin* ]] ; then
		sharedlib="-Wl,-install_name -Wl,${EPREFIX}/usr/$(get_libdir)/lib${PN}$(get_libname $(get_major_version))"
	fi

	sed -i \
		-e "s|#\(DSDPROOT[[:space:]]*=\).*|\1${S}|" \
		-e "s|\(CC[[:space:]]*=\).*|\1$(tc-getCC)|" \
		-e "s|\(OPTFLAGS[[:space:]]*=\).*|\1${CFLAGS}|" \
		-e "s|\(LAPACKBLAS[[:space:]]*=\).*|\1 $(pkg-config --libs blas lapack)|" \
		-e "s|\(^ARCH[[:space:]]*=\).*|\1$(tc-getAR) cr|" \
		-e "s|\(^RANLIB[[:space:]]*=\).*|\1$(tc-getRANLIB)|" \
		-e "s|libdsdp.so|lib${PN}$(get_libname $(get_major_version))|" \
		make.include
	# separate SH_LD due to weird sed behavior
	sed -i "s:SH_LD =:SH_LD=$(tc-getCC) -shared ${LDFLAGS} ${sharedlib}:g" \
		make.include
}

src_compile() {
	emake OPTFLAGS="${CFLAGS} -fPIC" dsdplibrary
}

src_test() {
	emake -j1 example test
}

src_install() {
	dolib.so lib/lib${PN}$(get_libname $(get_major_version))
	dosym lib${PN}$(get_libname $(get_major_version)) /usr/$(get_libdir)/lib${PN}$(get_libname)

	insinto /usr/include
	doins include/*.h src/sdp/*.h

	use doc && dodoc docs/*.pdf

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
