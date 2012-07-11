# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/dsdp/dsdp-5.8-r2.ebuild,v 1.3 2012/07/09 17:51:33 bicatali Exp $

EAPI=4

inherit toolchain-funcs flag-o-matic versionator

DESCRIPTION="C math library supporting IEEE 754 floating-point arithmetic"
HOMEPAGE="http://www.netlib.org/fdlibm"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

make_shared_lib() {
	local soname=$(basename "${1%.a}")$(get_libname $(get_major_version))
	einfo "Making ${soname}"
	${2:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		$([[ ${CHOST} == *-darwin* ]] && \
		echo "-Wl,-install_name -Wl,${EPREFIX}/usr/$(get_libdir)/${soname}") \
		-Wl,--whole-archive "${1}" -Wl,--no-whole-archive \
		-o $(dirname "${1}")/"${soname}" \
		-lm $(pkg-config --libs blas lapack) || return 1
	ln -s "${soname}" $(dirname "${1}")/$(basename "${1%.a}")$(get_libname)
}

src_compile() {
	append-cflags -D_IEEE_LIBM
	emake CFLAGS="${CFLAGS} -fPIC" CC=$(tc-getCC)
	mv libm.a lib${PN}.a
	make_shared_lib lib${PN}.a || die "doing shared lib failed"
	if use static-libs; then
		rm -f *.o
		emake CFLAGS="${CFLAGS}" CC=$(tc-getCC)
		mv libm.a lib${PN}.a
	fi
}

src_install() {
	dolib.so lib${PN}$(get_libname)*
	use static-libs && dolib.a lib${PN}.a
	insinto /usr/include
	doins fdlibm.h
	dodoc readme
}
