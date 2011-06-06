# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils cmake-utils

if [ "${PV}" != "9999" ]; then
	SRC_URI="boost? ( http://votca.googlecode.com/files/${PF}_pristine.tar.gz )
		!boost? ( http://votca.googlecode.com/files/${PF}.tar.gz )"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://tools.votca.googlecode.com/hg"
	EHG_REVISION="default"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-boost doc +fftw +gsl sqlite"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )
	dev-libs/expat
	gsl? ( sci-libs/gsl )
	boost? ( dev-libs/boost )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[-nodot] )
	>=app-text/txt2tags-2.5
	dev-util/pkgconfig"

src_prepare() {
	use gsl || ewarn "Disabling gsl will lead to reduced functionality"
	use fftw || ewarn "Disabling fftw will lead to reduced functionality"

	#remove bundled libs
	if use boost; then
		rm -rf src/libboost
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use boost EXTERNAL_BOOST)
		$(cmake-utils_use_with gsl GSL)
		$(cmake-utils_use_with fftw FFTW)
		$(cmake-utils_use_with sqlite SQLITE3)
		-DWITH_RC_FILES=OFF
	)
	cmake-utils_src_configure || die
}

src_install() {
	DOCS=(${CMAKE_BUILD_DIR}/CHANGELOG NOTICE)
	cmake-utils_src_install || die
	if use doc; then
		cd "${CMAKE_BUILD_DIR}" || die
		cd share/doc || die
		doxygen || die
		dohtml -r html/* || die
	fi
}
