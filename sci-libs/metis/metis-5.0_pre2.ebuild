# Copyright 1999-2007 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

MY_PV=${PV/_/}

DESCRIPTION="A package for unstructured serial graph partitioning"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/metis/index.html"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-${MY_PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="as-is"

IUSE="pcre openmp int64 threads"
SLOT="0"

DEPEND="pcre? ( dev-libs/libpcre )
	openmp? ( || ( >=sys-devel/gcc-4.2 >=dev-lang/icc-9 ) )"

S="${WORKDIR}/metis-${MY_PV}"

pkg_setup() {
	if use openmp \
		&& [[ $(tc-getCC) == *gcc ]] \
		&& [[  $(gcc-major-version)$(gcc-minor-version) -lt 42 ]]; then
			eerror "You need gcc >= 4.2 to use openmp features."
			eerror "Please use gcc-config to switch gcc version >= 4.2"
			die "setup gcc failed"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotools.patch
	if use int64; then
		sed -e 's/\(#define IDXTYPEWIDTH\).*32/\1 64/' \
			-i include/metis.h \
			|| die "sed for int64 failed"
	fi
	if use threads; then
		sed -e 's/\(#define HAVE_THREADLOCALSTORAGE\).*0/\1 1/' \
			-i include/metis.h \
			|| die "sed for threads failed"
	fi
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable pcre) \
		$(use_enable openmp) \
		|| die "econf failed"
	emake || die "emake failed"
}


src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	dodoc CHANGES.v5 INSTALL.v5 || die "dodoc failed"
}
