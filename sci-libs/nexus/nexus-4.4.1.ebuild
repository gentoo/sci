# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"
inherit cmake-utils fortran-2 java-pkg-opt-2

DESCRIPTION="Data format for neutron and x-ray scattering data"
HOMEPAGE="http://nexusformat.org/"
SRC_URI="https://github.com/nexusformat/code/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc cxx fortran -hdf4 +hdf5 java utils xml"

REQUIRED_USE=" || ( hdf4 hdf5 xml ) "

RDEPEND="
	xml? ( dev-libs/mxml )
	hdf4? ( sci-libs/hdf )
	hdf5? ( sci-libs/hdf5[zlib] )
	utils? ( sys-libs/readline:0 sys-libs/libtermcap-compat dev-libs/libxml2 )
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen dev-tex/xcolor )
"

S="${WORKDIR}/code-${PV}"

pkg_setup() {
	# Handling of dependencies between Fortran module files doesn't play well with parallel make
	use fortran && export MAKEOPTS="${MAKEOPTS} -j1 "
	use fortran && fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_configure() {
	# Linking between Fortran libraries gives a relocation error, using workaround suggested at:
	# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3
	use fortran && append-fflags -fPIC

	cmake-utils_src_configure \
		$(cmake-utils_use_enable hdf4) \
		$(cmake-utils_use_enable hdf5) \
		$(cmake-utils_use_enable xml MXML) \
		$(cmake-utils_use_enable cxx) \
		$(cmake-utils_use_enable fortran FORTRAN90) \
		$(cmake-utils_use_enable fortran FORTRAN77) \
		$(cmake-utils_use_enable java) \
		$(cmake-utils_use_enable utils APPS) \
		$(cmake-utils_use_enable utils CONTRIB)
}
