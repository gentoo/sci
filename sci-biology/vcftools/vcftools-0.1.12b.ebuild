# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/vcftools/vcftools-0.1.8.ebuild,v 1.2 2013/02/27 16:39:18 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

MY_P="${PN}_${PV}"

DESCRIPTION="Tools for working with VCF (Variant Call Format) files"
HOMEPAGE="http://vcftools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="lapack"

RDEPEND="lapack? ( virtual/lapack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# epatch "${FILESDIR}"/${P}-buildsystem.patch # patch is outdated
	sed -e 's#-O2#$(CXXFLAGS)#;s#-llapack#`$(PKG_CONFIG) --libs lapack`#' -i cpp/Makefile || die
	tc-export CXX PKG_CONFIG
}

src_compile() {
	local myconf
	use lapack && myconf="VCFTOOLS_PCA=1"
	emake -C cpp ${myconf}
}

src_install(){
	dobin cpp/${PN}
	insinto /usr/share/${PN}/perl
	doins perl/*.pm
	exeinto /usr/share/${PN}/perl
	doexe perl/{fill,vcf}-*
	echo 'COLON_SEPARATED=PERL5LIB' > "${S}/99${PN}"
	echo "PERL5LIB=/usr/share/${PN}/perl" >> "${S}/99${PN}"
	doenvd "${S}/99${PN}"
	dodoc README.txt
}
