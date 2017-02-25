# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit versionator

MPV=$(get_version_component_range 2-)

DESCRIPTION="Virtual Monte Carlo Geant4 implementation"
HOMEPAGE="http://root.cern.ch/root/vmc/VirtualMC.html"
SRC_URI="http://root.cern.ch/download/vmc/geant4_vmc.${MPV}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples vgm"

RDEPEND="
	sci-physics/root:=
	>=sci-physics/geant-4.9.6[opengl,geant3,examples?]
	vgm? ( sci-physics/vgm )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/geant4_vmc"

src_compile() {
	use vgm && export USE_VGM=1
	local dirs="g4root source"
	use examples && dirs+=" examples"
	local d
	source $(ls -1 "${EROOT}"usr/share/Geant4-*/geant4make/geant4make.sh) || die
	for d in ${dirs}; do
		pushd ${d} > /dev/null || die
		default
		if use doc; then
			doxygen || die
		fi
		popd > /dev/null
	done
}

src_test() {
	cd examples || die
	default
	./run_suite.sh || die
}

src_install() {
	dolib.so lib/tgt_*/{libg4root,libgeant4vmc}.so
	doheader -r include/*
	dodoc README history version_number
	use doc && dohtml -r Geant4VMC.html doc/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		emake -C examples clean
		doins -r examples
	fi
}
