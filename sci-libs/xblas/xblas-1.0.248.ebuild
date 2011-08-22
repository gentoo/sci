# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils flag-o-matic toolchain-funcs versionator

DESCRIPTION="Extra Precise Basic Linear Algebra Subroutines"
HOMEPAGE="http://www.netlib.org/xblas/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran static-libs"

DEPEND=""
RDEPEND=""

make_shared_lib() {
	local libstatic=${1}
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	shift
	einfo "Making ${soname}"
	${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
		"$@" -o $(dirname "${libstatic}")/"${soname}" || die "${soname} failed"
	ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
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
	make_shared_lib lib${PN}.a
}

src_test() {
	emake tests
}

src_install() {
	dolib.so lib${PN}.so*
	use static-libs && newlib.a lib${PN}_nonpic.a lib${PN}.a
	dodoc README README.devel
	use doc && dodoc doc/report.ps

	# pkg-config file for our multliple blas stuff
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
	doins ${PN}.pc || die
}
