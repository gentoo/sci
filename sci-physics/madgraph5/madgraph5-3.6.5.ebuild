# Distributed under the terms of the GNU General Public License v2

EAPI=8

# does not escape strings properly, so no python3_12 for now
PYTHON_COMPAT=( python3_{11..13} )
inherit fortran-2 python-single-r1 toolchain-funcs

MY_PNN="MadGraph5"
MY_PV=$(ver_rs 1-3 '_')
MY_PN="MG5_aMC_v"
MY_PF=${MY_PN}${MY_PV}

DESCRIPTION="MadGraph5_aMC@NLO"
HOMEPAGE="
	https://launchpad.net/mg5amcnlo
	https://github.com/mg5amcnlo/mg5amcnlo
"
SRC_URI="
	https://launchpad.net/mg5amcnlo/$(ver_cut 1).0/$(ver_cut 1-2).x/+download/${MY_PN}${PV}.tar.gz -> ${MY_PNN}-${PV}.tar.gz
	http://madgraph.phys.ucl.ac.be//Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V1.3.tar.gz
"
S="${WORKDIR}/${MY_PF}"

LICENSE="UoI-NCSA"
SLOT="3"
KEYWORDS="~amd64"
IUSE="+hepmc2 +lhapdf +fastjet +pythia +collier thepeg madanalysis5 +ninja samurai golem95 herwig yoda rivet"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-libs/zlib
	sys-devel/gcc:*[fortran]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	lhapdf? ( sci-physics/lhapdf[${PYTHON_SINGLE_USEDEP}] )
	fastjet? ( sci-physics/fastjet[${PYTHON_SINGLE_USEDEP}] )
	pythia? (
	sci-physics/pythia:8=[hepmc2(-),-hepmc3(-),examples]
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
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/cuttools.patch )

src_unpack() {
	# Perserve permissions
	tar xzf "${DISTDIR}/${MY_PNN}-${PV}.tar.gz" -C "${WORKDIR}" || die
	if use pythia; then
		mkdir -p "${S}/HEPTools/MG5aMC_PY8_interface/" || die
		tar xzf "${DISTDIR}/MG5aMC_PY8_interface_V1.3.tar.gz" -C "${S}/HEPTools/MG5aMC_PY8_interface/" || die
	fi
}

src_configure() {
	cat <<-EOF >> input/mg5_configuration.txt || die
	$(usex lhapdf "lhapdf_py3 = ${EPREFIX}/usr/bin/lhapdf-config" "")
	$(usex fastjet "fastjet = ${EPREFIX}/usr/bin/fastjet-config" "")
	$(usex pythia "pythia8_path = ${EPREFIX}/usr" "")
	$(usex pythia "mg5amc_py8_interface_path = ./HEPTools/MG5aMC_PY8_interface" "")
	$(usex hepmc2 "hepmc_path = ${EPREFIX}/usr" "")
	$(usex collier "collier = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex thepeg "thepeg_path = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex herwig "hwpp_path = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex ninja "ninja = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex samurai "samurai = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex golem95 "golem = ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex yoda "yoda_path= ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex rivet "rivet_path= ${EPREFIX}/usr/$(get_libdir)" "")
	$(usex madanalysis5 "madanalysis5_path = ${EPREFIX}/opt/MadAnalysis5/" "")
	auto_update = 0
	EOF
}

src_compile() {
	# MadGraph needs to generate `Template/LO/Source/make_opts` which is done
	# automatically at startup.  This needs to be done during setup (or with root access)
	if use pythia; then
		tc-export CXX
		cd HEPTools/MG5aMC_PY8_interface/ || die
		${CXX} ${CXXFLAGS} MG5aMC_PY8_interface.cc -o MG5aMC_PY8_interface $(pythia8-config --ldflags) -lHepMC  ${LDFLAGS} || die
		echo "$(pythia8-config --version)" >> PYTHIA8_VERSION_ON_INSTALL || die
		echo "$PV" >> MG5AMC_VERSION_ON_INSTALL || die
		cd ../.. || die
	fi
	echo "exit" >> tmpfile || die
	bin/mg5_aMC ./tmpfile || die
	rm tmpfile || die
	rm vendor/IREGI/src
}

src_install() {
	# symlink entrypoint
	dosym ../../opt/${MY_PF}/bin/mg5_aMC /usr/bin/mg5_aMC3
	dosym  ../opt/${MY_PF} /opt/"${MY_PNN}"
	mv "${WORKDIR}/${MY_PF}" "${ED}/opt/" || die
	dosym ../../../../../usr/$(get_libdir)/libiregi.a /opt/${MY_PF}/vendor/IREGI/src/libiregi.a
	dosym ../../../../../../../usr/$(get_libdir)/libqcdloop.a /opt/${MY_PF}/vendor/IREGI/src/qcdloop/ql/libqcdloop.a
	dosym ../../../../../usr/$(get_libdir)/libcts.a /opt/${MY_PF}/vendor/CutTools/includects/libcts.a
}
