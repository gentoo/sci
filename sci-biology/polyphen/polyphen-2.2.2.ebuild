# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Predict effect of aminoacid substitution on human protein function"
HOMEPAGE="http://genetics.bwh.harvard.edu/pph2/dokuwiki/start"
SRC_URI="
	http://genetics.bwh.harvard.edu/pph2/dokuwiki/_media/polyphen-${PV}r405d.tar.gz
	http://mafft.cbrc.jp/alignment/software/mafft-7.221-without-extensions-src.tgz
	http://prdownloads.sourceforge.net/weka/weka-3-6-12.zip
"

LICENSE="polyphen" # for non-commercial use only
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-perl/CGI
	sci-biology/ncbi-blast+
"
RDEPEND="${DEPEND}"

# 3.7GB
# ftp://genetics.bwh.harvard.edu/pph2/bundled/polyphen-2.2.2-databases-2011_12.tar.bz2

# 2.4GB
# ftp://genetics.bwh.harvard.edu/pph2/bundled/polyphen-2.2.2-alignments-mlc-2011_12.tar.bz2

# 895MB
# ftp://genetics.bwh.harvard.edu/pph2/bundled/polyphen-2.2.2-alignments-multiz-2009_10.tar.bz2

src_unpack() {
	unpack "polyphen-${PV}r405d.tar.gz"
	cp "${DISTDIR}/mafft-7.221-without-extensions-src.tgz" "${S}/src" || die
	cp "${DISTDIR}/weka-3-6-12.zip" "${S}/src" || die
}

src_configure() {
	# non-standard configure script
	./configure
}

src_compile() {
	pushd src
	emake -j1
	popd
}

src_install() {
	pushd src
	default
	popd
	einstalldocs
}
