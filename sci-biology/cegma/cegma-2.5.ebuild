# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Predict genes in a genome and use them for training to find all genes"
HOMEPAGE="http://korflab.ucdavis.edu/datasets/cegma"
SRC_URI="http://korflab.ucdavis.edu/datasets/cegma/CEGMA_v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/perl
	sci-biology/wise
	>=sci-biology/hmmer-3.0
	sci-biology/geneid
	sci-biology/ncbi-tools++"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/CEGMA_v${PV}

src_install(){
	dobin bin/*
	eval `perl '-V:installvendorlib'`
	vendor_lib_install_dir="${installvendorlib}"
	dodir ${vendor_lib_install_dir}/cegma
	insinto ${vendor_lib_install_dir}/cegma
	doins lib/*.pm

	echo "PERL5LIB="${vendor_lib_install_dir}"/cegma" > ${S}"/99cegma"
	# echo "CEGMATMP=/var/tmp" >> ${S}"/99cegma"
	doenvd ${S}"/99cegma" || die
}
