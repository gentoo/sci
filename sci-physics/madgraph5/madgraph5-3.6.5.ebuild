# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit fortran-2 python-single-r1

MY_PNN="MadGraph5"
MY_PV=$(ver_rs 1-3 '_')
MY_PN="MG5_aMC_v"
MY_PF=${MY_PN}${MY_PV}
MY_P=${MY_PNN}-${PV}

DESCRIPTION="MadGraph5_aMC@NLO"
HOMEPAGE="
	https://launchpad.net/mg5amcnlo
	https://github.com/mg5amcnlo/mg5amcnlo
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mg5amcnlo/mg5amcnlo"
	EGIT_BRANCH="3.x"
else
	SRC_URI="
	https://launchpad.net/mg5amcnlo/$(ver_cut 1).0/$(ver_cut 1-2).x/+download/${MY_PN}${PV}.tar.gz -> ${MY_P}.tar.gz
	http://madgraph.phys.ucl.ac.be//Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V1.3.tar.gz
"
	S="${WORKDIR}/${PF}"
	KEYWORDS="~amd64"
fi

LICENSE="UoI-NCSA"
SLOT="${PVR}"
IUSE="+hepmc2 +lhapdf +fastjet +pythia collier thepeg madanalysis5 ninja samurai golem95 herwig yoda rivet"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	sys-libs/zlib
	sys-devel/gcc:*[fortran]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')
	lhapdf? ( sci-physics/lhapdf[static-libs(-),${PYTHON_SINGLE_USEDEP}] )
	fastjet? ( sci-physics/fastjet[${PYTHON_SINGLE_USEDEP}] )
	pythia? (
		sci-physics/pythia:8=[static-libs(-),hepmc2(-),-hepmc3(-),examples]
		sci-physics/hepmc:2=
	)
	hepmc2? ( sci-physics/hepmc:2 )
	collier? ( sci-physics/collier[static-libs] )
	thepeg? (
		sci-physics/thepeg[hepmc3(-),fastjet?,lhapdf?]
	)
	madanalysis5? ( sci-physics/madanalysis5 )
	ninja? ( sci-physics/ninja[static-libs] )
	samurai? ( sci-physics/samurai )
	golem95? ( sci-physics/golem95 )
	herwig? ( sci-physics/herwig )
	yoda? ( sci-physics/yoda )
	rivet? ( sci-physics/rivet )
	sci-physics/cuttools
	sci-physics/iregi[static-libs]
	sci-physics/qcdloop[static-libs(-)]
"
RDEPEND="${DEPEND}"
# Wants to know madgraph5 version ...
PDEPEND="sci-physics/madgraph5-pythia8-interface"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6.5-nlo-template-libs.patch
	"${FILESDIR}"/${PN}-3.6.5-pythia-hepmc2.patch
	"${FILESDIR}"/${PN}-3.6.5-pythia-make.patch
	"${FILESDIR}"/${PN}-3.6.5-pythia-chmod.patch
)

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		# Perserve permissions
		tar xzf "${DISTDIR}/${MY_PNN}-${PV}.tar.gz" -C "${WORKDIR}" || die
		mv ${MY_PF} ${PF}
	fi
}

src_configure() {
	sed -i "s/LIBDIR=lib/LIBDIR=$(get_libdir)/g" Template/NLO/MCatNLO/srcPythia8/Makefile || die
	sed -i "s/LIBDIR=lib/LIBDIR=$(get_libdir)/g" Template/NLO/MCatNLO/srcPythia8/Makefile_hep || die

	cat <<-EOF >> input/mg5_configuration.txt || die
	$(usex lhapdf "lhapdf_py3 = ${EPREFIX}/usr/bin/lhapdf-config" "")
	$(usex fastjet "fastjet = ${EPREFIX}/usr/bin/fastjet-config" "")
	$(usex pythia "pythia8_path = ${EPREFIX}/usr" "")
	$(usex pythia "mg5amc_py8_interface_path = ${EPREFIX}/opt/madgraph5-pythia8-interface" "")
	$(usex hepmc2 "hepmc_path = ${EPREFIX}/usr" "")
	$(usex collier "collier = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex thepeg "thepeg_path = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex herwig "hwpp_path = ${EPREFIX}/usr/$(get_libdir)" "")
	ninja = $(usex ninja "${EPREFIX}/usr/$(get_libdir)" "''")
	samurai = $(usex samurai "${EPREFIX}/usr/$(get_libdir)" "''")
	golem = $(usex golem95 "${EPREFIX}/usr/$(get_libdir)" "''")
	$(usex yoda "yoda_path= ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex rivet "rivet_path= ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex madanalysis5 "madanalysis5_path = ${EPREFIX}/opt/MadAnalysis5/" "")
	auto_update = 0
	EOF
}

src_compile() {
	# MadGraph needs to generate `Template/LO/Source/make_opts` which is done
	# automatically at startup.  This needs to be done during setup (or with root access)
	echo "exit" >> tmpfile || die
	bin/mg5_aMC ./tmpfile || die
	rm tmpfile || die

	cd vendor/StdHEP || die
	emake all
	cd ../.. || die

#	cd vendor/CutTools || die
#	emake
#	cd ../.. || die
}

src_install() {
	# symlink entrypoint
	dosym ../../opt/${PF}/bin/mg5_aMC /usr/bin/mg5_aMC3-${PVR}
	mv "${WORKDIR}" "${ED}/opt/" || die

	dosym ../../../../../usr/$(get_libdir)/libiregi.a /opt/${PF}/vendor/IREGI/src/libiregi.a
	dosym ../../../../../../../usr/$(get_libdir)/libqcdloop.a /opt/${PF}/vendor/IREGI/src/qcdloop/ql/libqcdloop.a

	dosym ../../../../../usr/$(get_libdir)/libcts.a /opt/${PF}/vendor/CutTools/includects/libcts.a
	dosym ../../../../../usr/include/mpmodule.mod /opt/${PF}/vendor/CutTools/includects/mpmodule.mod
}
