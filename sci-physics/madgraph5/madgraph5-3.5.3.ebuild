# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# does not escape strings properly, so no python3_12 for now
PYTHON_COMPAT=( python3_11 )
inherit fortran-2 python-single-r1

MY_PNN="MadGraph5"
MY_PV=$(ver_rs 1-3 '_')
MY_PN="MG5_aMC_v"
MY_PF=${MY_PN}${MY_PV}

DESCRIPTION="MadGraph5_aMC@NLO"
HOMEPAGE="https://launchpad.net/mg5amcnlo"
SRC_URI="https://launchpad.net/mg5amcnlo/$(ver_cut 1).0/$(ver_cut 1-2).x/+download/${MY_PN}${PV}.tar.gz -> ${MY_PNN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="UoI-NCSA"
SLOT="3"
KEYWORDS="~amd64"
# TODO add pineapple, herwig, syscalc, pjfrym, pineappl
IUSE=" +hepmc +lhapdf +fastjet pythia collier thepeg" # td madanalysis5 ninja samurai golem95
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
	hepmc? (
		sci-physics/hepmc:2
		sci-physics/hepmc:3
	)
	collier? ( sci-physics/collier[static-libs] )
	thepeg? (
	sci-physics/thepeg[hepmc3(-),fastjet?,lhapdf?]
	)
"
#   madanalysis5? ( sci-physics/madanalysis5 )
#	td? ( sci-physics/topdrawer )
#	ninja? ( sci-physics/ninja[static-libs] )
#	samurai? ( sci-physics/samurai )
#	golem95? ( sci-physics/golem95 )
PATCHES=( "${FILESDIR}"/cuttools.patch )
DEPEND="${RDEPEND}"

src_unpack() {
	# Perserve permissions
	tar xvzf "${DISTDIR}/${MY_PNN}-${PV}.tar.gz" -C "${WORKDIR}"
}

src_configure() {
	cat << EOF >> input/mg5_configuration.txt || die
$(usex lhapdf "lhapdf_py3 = ${EPREFIX}/usr/bin/lhapdf-config" "")
$(usex fastjet "fastjet = ${EPREFIX}/usr/bin/fastjet-config" "")
$(usex pythia "pythia8_path = ${EPREFIX}/usr" "")
$(usex hepmc "hepmc_path = ${EPREFIX}/usr" "")
$(usex collier "collier = ${EPREFIX}/usr/$(get_libdir)" "")
$(usex thepeg "thepeg_path = ${EPREFIX}/usr/$(get_libdir)" "")
auto_update = 0
EOF
	#use ninja && echo "ninja = ${EPREFIX}/usr/$(get_libdir)" >> input/mg5_configuration.txt
	#use samurai && echo "samurai = ${EPREFIX}/usr/$(get_libdir)" >> input/mg5_configuration.txt
	#use golem95 && echo "golem = ${EPREFIX}/usr/$(get_libdir)" >> input/mg5_configuration.txt
	#use td && echo "td_path = ${EPREFIX}/usr/bin/td" >> input/mg5_configuration.txt
	#use madanalysis5 && echo "madanalysis5_path = ${EPREFIX}/opt/MadAnalysis5/" >> input/mg5_configuration.txt
}

src_compile() {
	# MadGraph needs to generate `Template/LO/Source/make_opts` which is done
	# automatically at startup.  This needs to be done during setup (or with root access)
	echo "exit" > tmpfile || die
	bin/mg5_aMC ./tmpfile || die
	rm tmpfile || die
}

src_install() {
	# symlink entrypoint
	dosym ../../opt/${MY_PF}/bin/mg5_aMC /usr/bin/mg5_aMC3
	dosym  ../opt/${MY_PF} /opt/"${MY_PNN}"
	mv "${WORKDIR}/${MY_PF}" "${ED}/opt/"

	# allow all users to modify mg directory
	# as it changes it self
	#fperms -R a=u /opt/${MY_PF}
	#fperms a=u /opt/${MY_PF}
}
