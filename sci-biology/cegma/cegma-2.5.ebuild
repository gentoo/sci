# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Predict genes in a genome and use them for training to find all genes"
HOMEPAGE="http://korflab.ucdavis.edu/datasets/cegma"
SRC_URI="http://korflab.ucdavis.edu/datasets/cegma/CEGMA_v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sci-biology/wise
	sci-biology/geneid
	sci-biology/ncbi-tools++"
	# >=sci-biology/hmmer-3.0
RDEPEND="${DEPEND}"

S="${WORKDIR}"/CEGMA_v${PV}

src_install(){
	dobin bin/*
	perl_set_version
	insinto ${VENDOR_LIB}
	doins lib/*.pm
}

pkg_postinst(){
	ewarn "cegma needs >=sci-biology/hmmer-3.0 but sci-biology/wise uses sci-biology/hmmer-2.3"
	ewarn "hmmer-3 is not backwards compatible and does not even have all its previous features"
	ewarn "Therefore, we do not list hmmer in the list of DEPENDENCIES."
}
