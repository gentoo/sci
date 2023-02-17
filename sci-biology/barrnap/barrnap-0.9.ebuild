# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Predict Bacterial and Archaeal rRNA genes and output in GFF3 format"
HOMEPAGE="https://github.com/tseemann/barrnap"
SRC_URI="https://github.com/tseemann/barrnap/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# contains bundled binaries of hmmer-3.1 (dev version)
# needs >=perl-5.6

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl:=
	"

src_install(){
	# the below recreates the whole layout
	insinto /usr/share/"${PN}"/bin
	doins bin/barrnap
	chmod a+rx "${ED}"/usr/share/"${PN}"/bin/barrnap || die
	insinto /usr/share/"${PN}"/binaries/linux
	doins binaries/linux/nhmmer
	chmod a+rx "${ED}"/usr/share/"${PN}"/binaries/linux/nhmmer || die
	insinto /usr/share/"${PN}"/db
	doins db/*
	insinto /usr/share/"${PN}"/examples
	doins examples/*

	echo PATH=/usr/share/"${PN}"/bin:$PATH > "${S}"/99barrnap
	doenvd "${S}"/99barrnap

	dodoc README.md
}
