# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="HMM-based cDNA to genome aligner"
HOMEPAGE="http://mblab.wustl.edu/software.html"
SRC_URI="http://mblab.wustl.edu/software/download/pairagon_.tar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/pairagon

src_prepare(){
	sed -e 's:src/get-glib-flags.sh:#src/get-glib-flags.sh:; s:-Wall -Werror::' -i Makefile
}

src_compile(){
	emake pairagon-linux
}

src_install(){
	# emake DESTDIR="${D}"/usr install
	dobin bin/*
	dodoc README
	insinto /usr/share/pairagon
	doins parameters/*
	eval `perl '-V:installvendorlib'`
	vendor_lib_install_dir="${installvendorlib}"
	dodir ${vendor_lib_install_dir}/pairagon
	insinto ${vendor_lib_install_dir}/pairagon
	doins lib/perl5/Alignment.pm
	echo "PERL5LIB="${vendor_lib_install_dir}"/pairagon" > ${S}"/99pairagon"
	doenvd ${S}"/99pairagon" || die
}
