# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils fortran-2 multilib

IUSE="+dipro +system-boost"
if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://ctp.votca-ctp.googlecode.com/hg"
	EHG_REVISION="default"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Votca charge transport code"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="=sci-libs/votca-tools-${PV}[system-boost=]
	=sci-chemistry/votca-csg-${PV}
	=sci-chemistry/votca-moo-${PV}
	dipro? ( virtual/fortran
		virtual/lapack )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( README NOTICE )

pkg_setup() {
	use dipro && fortran-2_pkg_setup
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use system-boost EXTERNAL_BOOST)
		$(cmake-utils_use_with dipro DIPRO)
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}
