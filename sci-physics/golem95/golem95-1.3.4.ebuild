# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2

DESCRIPTION="performs the reduction to a certain set of basis integrals numerically"
HOMEPAGE="
	https://golem.hepforge.org/
	https://github.com/gudrunhe/golem95
"
SRC_URI="https://github.com/gudrunhe/golem95/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+looptools"
RDEPEND="
	sci-physics/oneloop[dpkind,qpkind16,-qpkind]
	looptools? ( sci-physics/looptools )
"
DEPEND="${REPEND}"

src_prepare() {
	default
	# if uses looptools
	if use looptools; then
		# add -looptools to pkgconfig
		sed -i '/Libs:/s/$/ -looptools/' golem95.pc.in || die
	fi
	sed -i 's/lib_LTLIBRARIES.*/lib_LTLIBRARIES = libgolem.la/g' Makefile.am || die
	eautoreconf
}

src_configure() {
	local -x CONFIG_SHELL="${BROOT}/bin/bash"
	# Fix that qcdloop and oneloop are already installed
	local myconf=(
		--with-avh_olo_precision=double
		--with-precision=double
		$(use_with looptools looptools "${ESYSROOT}"/usr)
		FCFLAGS="${FCFLAGS} -std=legacy -fPIC -I${ESYSROOT}/usr/include"
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake -j1
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
