# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs autotools

MY_P="${PN}_${PV}"

DESCRIPTION="Tools for working with VCF (Variant Call Format) files"
HOMEPAGE="https://vcftools.github.io
	http://vcftools.sourceforge.net"
SRC_URI="https://github.com/vcftools/vcftools/archive/vcftools-vcftools-v0.1.14-14-g2543f81.tar.gz"
#SRC_URI="https://codeload.github.com/vcftools/vcftools/legacy.tar.gz/master -> ${P}.tar.gz"
#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="lapack"

RDEPEND="lapack? ( virtual/lapack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/vcftools-vcftools-2543f81
#S="${WORKDIR}/${MY_P}"

src_prepare() {
	# epatch "${FILESDIR}"/${P}-buildsystem.patch
	tc-export CXX PKG_CONFIG
	eautoreconf
}

src_configure(){
	econf --enable-pca # --with-pmdir=DIR   install Perl modules in DIR
}

#src_compile() {
#	local myconf
#	use lapack && myconf="VCFTOOLS_PCA=1"
#	emake -C cpp ${myconf}
#}

src_install(){
	perl_set_version
	dobin src/cpp/"${PN}"
	doman src/cpp/"${PN}".1
	insinto "${VENDOR_LIB}"
	doins src/perl/*.pm
	dobin src/perl/{fill,vcf}-*
	dodoc README.md
}
