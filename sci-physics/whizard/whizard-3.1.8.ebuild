# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit fortran-2 optfeature python-single-r1

DESCRIPTION="The WHIZARD Event Generator"
HOMEPAGE="
	https://whizard.hepforge.org/
	https://gitlab.tp.nt.uni-siegen.de/whizard/public
"

SRC_URI="https://whizard.hepforge.org/downloads?f=${P}.tar.gz -> ${P}.tar.gz" # weird hepforge download names
#S="${WORKDIR}/${P}"
KEYWORDS="~amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE="+omega +lhapdf +looptools +hepmc openloops recola qgraf form pythia8 hoppet fastjet samurai ninja mpi +openmp python gosam lcio"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	lcio? ( python )
"

RDEPEND="
	dev-ml/ocamlbuild
	lhapdf? (
		sci-physics/lhapdf
		sci-physics/lhapdf-sets[lhapdf_sets_ct10,lhapdf_sets_ct10nlo,lhapdf_sets_cteq6l1]
	)
	looptools? ( sci-physics/looptools )
	hepmc? ( || ( sci-physics/hepmc:2 sci-physics/hepmc:3 ) )

	recola? ( sci-physics/recola2 )
	openloops? ( sci-physics/openloops )

	qgraf? ( sci-physics/qgraf )
	form? ( sci-mathematics/form )
	pythia8? ( sci-physics/pythia:8 )
	hoppet? ( sci-physics/hoppet )
	fastjet? ( sci-physics/fastjet )
	samurai? ( sci-physics/samurai )
	ninja? ( sci-physics/ninja )
	mpi? ( virtual/mpi[fortran,cxx] )
	python? ( ${PYTHON_DEPS} )
	gosam? ( sci-physics/gosam )
	lcio? ( sci-physics/lcio[${PYTHON_SINGLE_USEDEP}] )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	CONFIG_SHELL=${BROOT}/bin/bash econf \
		--disable-default-UFO-dir \
		$(usex mpi FC=mpifort) \
		$(usex mpi CC=mpicc) \
		$(usex mpi CXX=mpic++) \
		$(usex mpi --with-mpi-lib=openmpi) \
		$(use_enable mpi fc-mpi) \
		$(use_enable openmp) \
		$(use_enable openmp fc-openmp) \
		$(use_enable omega) \
		$(use_enable lhapdf) \
		$(use_enable looptools) \
		$(use_enable hepmc) \
		$(use_enable pythia8) \
		$(use_enable hoppet) \
		$(use_enable fastjet) \
		$(use_enable openloops) \
		$(use_enable recola) \
		$(use_with form) \
		$(use_with qgraf) \
		$(use_with ninja) \
		$(use_with samurai) \
		$(use_enable python) \
		$(use_enable gosam) \
		$(use_enable lcio)

}

pkg_postinst() {
	optfeature "visualisation latex" dev-texlive/texlive-metapost
}
