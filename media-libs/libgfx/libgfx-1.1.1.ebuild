# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simplify the creation of computer graphics software"
HOMEPAGE="http://mgarland.org/software/libgfx.html"

if [[ ${PV} == "1.1.1" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mjgarland/libgfx"
	EGIT_BRANCH="branch-1.1.1"
else
	SRC_URI="http://mgarland.org/dist/${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	virtual/opengl
	x11-libs/fltk
"

RDEPEND="${DEPEND}"

src_compile() {
	cd src || die
	default
}

src_install() {
	use static-libs && dolib.a src/*.a
	doheader include/gfx/gfx.h

	dodoc doc/*
}

src_test() {
	cd tests || die
	sed -i -e 's/t-vec.cxx t-img.cxx t-gui.cxx t-glimg.cxx t-script.cxx t-glext.cxx/t-vec.cxx t-img.cxx t-script.cxx/' Makefile
	emake
}
