# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs flag-o-matic versionator multilib

DESCRIPTION="C math library supporting IEEE 754 floating-point arithmetic"
HOMEPAGE="http://www.netlib.org/fdlibm"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version)) || die
		ln -s ${soname} ${libdir}/${libname}$(get_libname) || die
	fi
}

src_compile() {
	append-cflags -D_IEEE_LIBM
	emake CFLAGS="${CFLAGS} -fPIC" CC=$(tc-getCC)
	mv libm.a lib${PN}.a || die
	static_to_shared lib${PN}.a
	if use static-libs; then
		rm -f *.o || die
		emake CFLAGS="${CFLAGS}" CC=$(tc-getCC)
		mv libm.a lib${PN}.a || die
	fi
}

src_install() {
	dolib.so lib${PN}$(get_libname)*
	use static-libs && dolib.a lib${PN}.a
	doheader fdlibm.h
	dodoc readme
}
