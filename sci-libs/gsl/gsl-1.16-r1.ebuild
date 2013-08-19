# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit alternatives-2 autotools-utils eutils toolchain-funcs

DESCRIPTION="GNU Scientific Library"
HOMEPAGE="http://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cblas-external static-libs"

RDEPEND="cblas-external? ( virtual/cblas )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-cblas-external.patch )

src_configure() {
	if use cblas-external; then
		export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
		export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
	fi
	local myeconfargs=(
		$(use_with cblas-external)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	local libname=gslcblas

	cat <<-EOF > ${libname}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${libname}
		Description: ${DESCRIPTION} CBLAS implementation
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${libname}
		Libs.private: -lm
		Cflags: -I\${includedir}
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${libname}.pc

	# Don't add gsl as a cblas alternative if using cblas-external
	use cblas-external || alternatives_for cblas gsl 0 \
		/usr/$(get_libdir)/pkgconfig/cblas.pc ${libname}.pc \
		/usr/include/cblas.h gsl/gsl_cblas.h
}
