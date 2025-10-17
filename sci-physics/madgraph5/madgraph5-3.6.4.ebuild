# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# does not escape strings properly, so no python3_12 for now
PYTHON_COMPAT=( python3_{11..13} )
inherit fortran-2 python-single-r1

MY_PNN="MadGraph5"
MY_PV=$(ver_rs 1-3 '_')
MY_PN="MG5_aMC_v"
MY_PF=${MY_PN}${MY_PV}

DESCRIPTION="MadGraph5_aMC@NLO"
HOMEPAGE="
	https://launchpad.net/mg5amcnlo
	https://github.com/mg5amcnlo/mg5amcnlo
"
SRC_URI="https://launchpad.net/mg5amcnlo/$(ver_cut 1).0/$(ver_cut 1-2).x/+download/${MY_PN}${PV}.tar.gz -> ${MY_PNN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="UoI-NCSA"
SLOT="3"
KEYWORDS="~amd64"
IUSE="+hepmc2 +lhapdf +fastjet pythia collier thepeg madanalysis5 ninja samurai golem95 herwig yoda rivet"
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
	pythia? ( sci-physics/pythia:8=[examples] )
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
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/cuttools.patch )

src_unpack() {
	# Perserve permissions
	tar xvzf "${DISTDIR}/${MY_PNN}-${PV}.tar.gz" -C "${WORKDIR}" || die
}

src_configure() {
	cat <<-EOF >> input/mg5_configuration.txt || die
	$(usex lhapdf "lhapdf_py3 = ${EPREFIX}/usr/bin/lhapdf-config" "")
	$(usex fastjet "fastjet = ${EPREFIX}/usr/bin/fastjet-config" "")
	$(usex pythia "pythia8_path = ${EPREFIX}/usr" "")
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
	echo "exit" > tmpfile || die
	bin/mg5_aMC ./tmpfile || die
	rm tmpfile || die
	cd vendor/CutTools || die
	emake -j1
	cd ../IREGI/src || die
	emake -j1 -f makefile_ML5_lib
}

src_install() {
	# symlink entrypoint
	dosym ../../opt/${MY_PF}/bin/mg5_aMC /usr/bin/mg5_aMC3
	dosym  ../opt/${MY_PF} /opt/"${MY_PNN}"
	mv "${WORKDIR}/${MY_PF}" "${ED}/opt/" || die

	# allow all users to modify mg directory
	# as it changes it self
	#fperms -R a=u /opt/${MY_PF}
	#fperms a=u /opt/${MY_PF}
}
