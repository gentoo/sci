# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 multilib

DESCRIPTION="PacBio modified BAM file format"
HOMEPAGE="https://pbbam.readthedocs.io/en/latest/index.html"
EGIT_REPO_URI="https://github.com/PacificBiosciences/pbbam.git"

LICENSE="blasr"
SLOT="0"
IUSE="hdf5 doc"
KEYWORDS=""
# https://github.com/PacificBiosciences/pbbam/issues/25

CDEPEND="
	dev-util/meson
	dev-util/ninja
	dev-util/pkgconfig
	>=dev-cpp/gtest-1.8.1
	>=dev-lang/swig-3.0.5
	doc? ( app-doc/doxygen )"
DEPEND="
	>=sci-libs/htslib-1.3.1:=
	>=dev-libs/boost-1.55:=[threads]
	hdf5? ( >=sci-libs/hdf5-1.8.12[cxx] )" # needs H5Cpp.h
RDEPEND=""

#S="${WORKDIR}/${PN}"

src_compile(){
	mkdir -p build || die
	cd build || die
	meson --prefix "${ED}/usr" || die
	ninja || die
	use doc && ( ninja doc )
}

src_install() {
	cd build || die
	ninja install || die
	#dobin bin/*
	#insinto /usr/include
	#doins include/*
	#insinto /usr/$(get_libdir)/${P}
	#doins lib/*
}
