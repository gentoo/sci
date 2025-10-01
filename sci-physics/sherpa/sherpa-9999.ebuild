# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake fortran-2 python-single-r1

MY_PN="SHERPA-MC"
MY_PV=${PV//_/}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="Simulation of High-Energy Reactions of PArticles"
HOMEPAGE="
	https://sherpa-team.gitlab.io/
	https://gitlab.com/sherpa-team/sherpa
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/sherpa-team/sherpa"
	EGIT_BRANCH="master"
else
	#SRC_URI="https://www.hepforge.org/archive/sherpa/${MY_P}.tar.gz"
	SRC_URI="https://gitlab.com/sherpa-team/${PN}/-/archive/v${MY_PV}/${PN}-v${MY_PV}.tar.bz2"
	S="${WORKDIR}/${PN}-v${MY_PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="+fastjet +pythia6 pythia8 rivet ufo hepmc2 root gzip mpi lhole analysis openloops" # blackhat recola gosam hztool madloop pgs mcfm
REQUIRED_USE="
	ufo? ( ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	sci-physics/lhapdf
	dev-db/sqlite:3=
	sci-physics/hepmc:3=
	dev-libs/libzip
	rivet? ( sci-physics/rivet )
	gzip? ( app-arch/gzip )
	pythia8? ( sci-physics/pythia:8= )
	hepmc2?  ( sci-physics/hepmc:2= )
	fastjet? ( sci-physics/fastjet )
	root? ( sci-physics/root )
	mpi? ( virtual/mpi[cxx,fortran] )
	ufo? ( ${PYTHON_DEPS} )
	openloops? ( sci-physics/openloops[openloops_processes_ppllj(-),openloops_processes_pplljj(-)] )
"
#	blackhat? ( sci-physics/blackhat )
#	gosam? ( sci-physics/gosam )
#	recola? ( sci-physics/recola )
RDEPEND="${DEPEND}"

pkg_setup() {
	use ufo && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DSHERPA_ENABLE_THREADING=ON
		-DSHERPA_ENABLE_ANALYSIS=$(usex analysis ON OFF)
		-DSHERPA_ENABLE_GZIP=$(usex gzip ON OFF)
		-DSHERPA_ENABLE_HEPMC2=$(usex hepmc2 ON OFF)
		-DSHERPA_ENABLE_HEPMC3=ON
		-DSHERPA_ENABLE_LHAPDF=ON
		-DSHERPA_ENABLE_LHOLE=$(usex lhole ON OFF)
		-DSHERPA_ENABLE_MPI=$(usex mpi ON OFF)
		$(usex mpi -DCMAKE_C_COMPILER=mpicc)
		$(usex mpi -DCMAKE_CXX_COMPILER=mpic++)
		$(usex mpi -DCMAKE_Fortran_COMPILER=mpif90)
		-DSHERPA_ENABLE_PYTHIA6=$(usex pythia6 ON OFF)
		-DSHERPA_ENABLE_PYTHIA8=$(usex pythia8 ON OFF)
		-DSHERPA_ENABLE_RIVET=$(usex rivet ON OFF)
		-DSHERPA_ENABLE_ROOT=$(usex root ON OFF)
		-DSHERPA_ENABLE_UFO=$(usex ufo ON OFF)
		-DSHERPA_ENABLE_OPENLOOPS=$(usex openloops ON OFF)
		-DOPENLOOPS_PREFIX=$(usex openloops "${ESYSROOT}/opt/OpenLoops2")
		#-DSHERPA_ENABLE_GOSAM=$(usex gosam ON OFF)
		#-DSHERPA_ENABLE_BLACKHAT=$(usex blackhat ON OFF)
		#-DSHERPA_ENABLE_RECOLA=$(usex recola ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	use ufo && python_optimize
}
