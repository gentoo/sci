# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-opt-2

DESCRIPTION="Data format for neutron and x-ray scattering data"
HOMEPAGE="http://nexusformat.org/"

COMMIT=5b803b3a0014bd9759b3d846da3cd3c1cfafd7d5
SRC_URI="https://github.com/nexusformat/code/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/code-${COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cxx hdf4 +hdf5 java xml"

REQUIRED_USE="|| ( hdf4 hdf5 xml )"

RESTRICT="test"

DEPEND="
	dev-libs/libxml2
	sys-libs/readline
	sys-libs/libtermcap-compat
	xml? ( dev-libs/mxml )
	hdf4? ( sci-libs/hdf )
	hdf5? ( sci-libs/hdf5[zlib] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/doxygen[dot]
"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	# no fortran, doesn't compile
	local mycmakeargs=(
		-DENABLE_APPS=ON
		-DENABLE_CONTRIB=ON
		-DENABLE_HDF4=$(usex hdf4)
		-DENABLE_HDF5=$(usex hdf5)
		-DENABLE_MXML=$(usex xml)
		-DENABLE_CXX=$(usex cxx)
		-DENABLE_FORTRAN90=NO
		-DENABLE_FORTRAN77=NO
		-DENABLE_JAVA=$(usex java)
	)
	cmake_src_configure
}
