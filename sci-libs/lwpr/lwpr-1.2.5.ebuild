# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="The Locally Weighted Projection Regression Library"
HOMEPAGE="http://www.ipab.inf.ed.ac.uk/slmc/software/lwpr/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples octave static-libs"

RDEPEND="
	octave? ( >=sci-mathematics/octave-3 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local myeconfargs=(
		--enable-threads=3
		$(use_with octave octave "$(octave-config -p PREFIX)")
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	autotools-utils_src_install \
		 mexflags="-DMATLAB -I../include -L./.libs -llwproctave"
	use doc && dodoc doc/lwpr_doc.pdf && dohtml html/*
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins example_c/cross.c example_cpp/cross.cc
	fi
	if use octave; then
		insinto /usr/share/octave/packages/${P}
		doins matlab/*.m
	fi
}
