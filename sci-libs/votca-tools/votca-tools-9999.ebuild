# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils eutils multilib

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://downloads.votca.googlecode.com/hg/${P}_pristine.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://code.google.com/p/votca.tools/"
	KEYWORDS=""
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc +fftw +gsl sqlite"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )
	dev-libs/expat
	gsl? ( sci-libs/gsl )
	dev-libs/boost:=
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	doc? ( || ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot]	) )
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

DOCS=( NOTICE )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with gsl GSL)
		$(cmake-utils_use_with fftw FFTW)
		$(cmake-utils_use_with sqlite SQLITE3)
		-DWITH_RC_FILES=OFF
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		cd "${CMAKE_BUILD_DIR}"
		cmake-utils_src_make html
		dohtml -r share/doc/html/*
	fi
}
