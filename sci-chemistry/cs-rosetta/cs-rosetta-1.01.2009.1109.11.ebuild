# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="System for chemical shifts based protein structure prediction using ROSETTA"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/CSROSETTA/"
SRC_URI="
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/install.com -> ${P}-install.com
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/CSRosetta.tar.Z -> ${P}.tar.Z
	http://spin.niddk.nih.gov/bax/software/CSROSETTA/changeLog -> ${P}-changelog"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS=""
IUSE="custom-cflags"

RDEPEND="
	dev-lang/perl
	|| ( sci-biology/update-blastdb sci-biology/ncbi-tools++ )
	sci-biology/profphd
	sci-biology/psipred
	sci-biology/samtools
	~sci-libs/cs-rosetta-db-${PV}
	sci-chemistry/nmrpipe
	sci-chemistry/rosetta"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${P}.tar.Z
}

src_prepare() {
	cat >> "${T}"/39${PN} <<- EOF
	rosetta3="${EPREFIX}/usr/bin/AbinitioRelax"
	rosetta3_extpdbs="${EPREFIX}/usr/bin/extract_pdbs"
	rosetta3DB="${EPREFIX}/usr/share/rosetta-db"
	csrosettaDir="${EPREFIX}/opt/${PN}"
	csrosettaCom="${EPREFIX}/opt/${PN}/com"
	PATH="${EPREFIX}/opt/${PN}/com"
	MFR="${EPREFIX}/opt/${PN}/com/mfr.tcl"
	EOF

	# needs more love
	sed \
		-e "s:CSROSETTA_DIR/src/nnmake/pNNMAKE.gnu:${EPREFIX}/opt/${PN}/src/nnmake/pNNMAKE:g" \
		-i com/make_fragments_2000.pl || die

	append-fflags -ffixed-line-length-132
}

src_compile() {
	use custom-cflags || CXXFLAGS="-pipe -ffor-scope -fno-exceptions -O3 -ffast-math -funroll-loops -finline-functions -finline-limit=20000"

	compilation() {
		if [[ -f dipolar_nn.f ]]; then
			sed \
				-e '/write/s:(i,6f6.3):(i3,6(1x,f6.3)):g' \
				-i dipolar_nn.f || die
		fi

		sed \
			-e '/LDFLAGS/s: = : ?= :g' \
			-e '/CCFLAGS/s: = : += :g' \
			-e 's:$(OBJECT) $(LDFLAGS):$(LDFLAGS) $(OBJECT) -lm -o:g' \
			-e 's:$(FFLAGS) -o:$(FFLAGS) $(LDFLAGS) -o:g' \
			-e '/make.system/d' \
			-i *akefile || die
		emake \
			CC=$(tc-getCXX) \
			CCFLAGS="${CXXFLAGS}"

		if [[ -f pNNMAKE. ]]; then
			mv pNNMAKE{.,} || die
			emake almostsuperclean
		else
			emake clean
		fi
	}

	for i in src/{mfr2rosetta,SPARTA/src,pdbrms,TALOS,rosettaFrag2csFrag,nnmake}; do
		pushd ${i} > /dev/null
			compilation
		popd > /dev/null
	done
}

src_install() {
	insinto /opt/${PN}/
	doins -r *
	chmod 755 \
		"${ED}"/opt/${PN}/com/* \
		"${ED}"/opt/${PN}/src/{mfr2rosetta/mfr2rosetta,SPARTA/src/SPARTA,pdbrms/pdbrms,TALOS/TALOS,rosettaFrag2csFrag/rosettaFrag2csFrag,nnmake/pNNMAKE} \
		 || die

	dosym make_fragments_2000.pl /opt/${PN}/com/make_fragment_2000.pl

	doenvd "${T}"/39${PN}
}
