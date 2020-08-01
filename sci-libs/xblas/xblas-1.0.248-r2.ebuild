# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NUMERIC_MODULE_NAME="xblas"
FORTRAN_NEEDED=fortran

inherit flag-o-matic fortran-2 toolchain-funcs out-of-source autotools

DESCRIPTION="Extra Precise Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.netlib.org/xblas"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs"

DEPEND=""
RDEPEND="${RDEPEND}"
BDEPEND="sys-devel/m4
	fortran? ( virtual/fortran )"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(ver_cut 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
		-Wl,-all_load -Wl,${libstatic} \
		"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		local components=($(ver_rs 1- ' '))

		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname=${soname} \
		-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
		"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ ${#components[@]} -gt 1 ]] && \
		ln -s ${soname} ${libdir}/${libname}$(get_libname $(ver_cut 1)) || die
		ln -s ${soname} ${libdir}/${libname}$(get_libname) || die
	fi
}

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	default

	export M4_OPTS="-I ${S} -I ${S}/m4"
	eautoreconf
}

src_configure() {
	AT_M4DIR=${S}
	out-of-source_src_configure
	export FCFLAGS="${FCFLAGS} $(get_abi_CFLAGS)"
	econf $(use_enable fortran)
}

src_compile() {
	# default target builds and runs tests - split
	# build first static libs because of fPIC afterwards
	# and we link tests with shared ones
	if use static-libs; then
		emake makefiles
		emake lib
		emake clean
	fi
	sed -i \
		-e 's:\(CFLAGS.*\).*:\1 -fPIC:' \
		make.inc || die
	emake makefiles
	emake lib
	static_to_shared libxblas.a
}

src_install() {
	dodir /usr/include
	doheader "${S}"/src/blas*.h
	dolib.so "${S}"/libxblas.so*
	dolib.a "${S}"/libxblas.a

	dodir /usr/"$(get_libdir)"/pkg-config
	insinto /usr/"$(get_libdir)"/pkg-config
	doins "${FILESDIR}"/xblas.pc

	dodoc README README.devel doc/report.ps
}
