# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils autotools-utils

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://tools.votca.googlecode.com/hg"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-boost doc +fftw +gsl static-libs"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )
	dev-libs/expat
	gsl? ( sci-libs/gsl )
	boost? ( dev-libs/boost )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	>=app-text/txt2tags-2.5
	dev-util/pkgconfig"

src_prepare() {
	use gsl || ewarn "Disabling gsl will lead to reduced functionality"
	use fftw || ewarn "Disabling fftw will lead to reduced functionality"

	#remove bundled libs
	rm -rf src/libexpat
	if use boost; then
		rm -rf src/libboost
	else
		#fix a qa issue ../../config is not support as m4 dir
		mkdir -p src/libboost/config
		sed -i 's@\.\./\.\./config@config@' \
			src/libboost/configure.ac \
			src/libboost/Makefile.am
	fi
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf
	use boost && myconf="--disable-votca-boost" || myconf="--enable-votca-boost"

	myeconfargs=( ${myconf} --disable-rc-files
		$(use_with gsl)
		$(use_with fftw)
	)
	autotools-utils_src_configure
}

src_install() {
	DOCS=(${AUTOTOOLS_BUILD_DIR}/CHANGELOG NOTICE)
	autotools-utils_src_install
	if use doc; then
		cd share/doc
		doxygen || die
		dohtml -r html/*
	fi
}
