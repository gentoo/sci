# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic fortran-2 multilib toolchain-funcs versionator

DESCRIPTION="Extra Precise Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.netlib.org/xblas"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran static-libs"

RDEPEND="fortran? ( virtual/fortran )"
DEPEND="${RDEPEND}"

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
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	econf $(use_enable fortran)
}

src_compile() {
	# default target builds and runs tests - split
	# build first static libs because of fPIC afterwards
	# and we link tests with shared ones
	if use static-libs; then
		emake makefiles
		emake lib XBLASLIB=lib${PN}_nonpic.a
		emake clean
	fi
	sed -i \
		-e 's:\(CFLAGS.*\).*:\1 -fPIC:' \
		make.inc || die
	emake makefiles
	emake lib
	static_to_shared lib${PN}.a
}

src_test() {
	emake tests
}

src_install() {
	dolib.so lib${PN}$(get_libname)*
	use static-libs && newlib.a lib${PN}_nonpic.a lib${PN}.a
	dodoc README README.devel
	use doc && dodoc doc/report.ps

	# pkg-config file for our multliple numeric stuff
	cat > ${PN}.pc <<-EOF
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/${PN}
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${PN}
		Cflags: -I\${includedir}
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
