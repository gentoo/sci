# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Transcript annotation workflow"
HOMEPAGE="http://brendelgroup.org/bioinformatics2go/mRNAmarkup.php"
SRC_URI="http://www.brendelgroup.org/bioinformatics2go/Download/mRNAmarkup-4-8-2015.tar.gz" # 184MB

# mRNAmarkup-4-8-2015.tar.gz is 1.1 version

LICENSE="mRNAmarkup"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sci-biology/ncbi-tools++
	sci-biology/estscan"
# sci-biology/MuSeqBox has fetch-restrict and probably only works with old BLAST plaintex output
# but, mRNAmarkup/INSTALL says:
# 'For convenience, a copy of the MuSeqBox code distribution is included in directory src/contributed
#
# has a slightly modified estscan copy in src/contributed
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"

src_prepare(){
	sed -e \
		"s#configfile=$installdir/mRNAmarkup.conf#configfile=/usr/share/mRNAmarkup/etc/mRNAmarkup.conf#" \
		-i bin/mRNAmarkup.orig || die
	sed -e \
		"s#$installdir/bin/ESTScan.conf#/usr/share/mRNAmarkup/etc/ESTScan.conf#" \
		-i bin/mRNAmarkup.orig
}

src_compile(){
	cd src
	emake
}

src_install(){
	mv bin/mRNAmarkup.orig bin/mRNAmarkup
	sed -e 's#INSTALLDIR#/usr/share/mRNAmarkup/etc/#' -i bin/mRNAmarkup
	dobin bin/mRNAmarkup bin/*.pl bin/dnatopro bin/genestat
	# TODO: there are some more files in bin/ , sigh!
	insinto /usr/share/mRNAmarkup/etc
	mv mRNAmarkup.conf.orig mRNAmarkup.conf
	doins mRNAmarkup.conf
	doins bin/ESTScan.conf
	dodoc 0README INSTALL
}

pkg_postinst(){
	einfo "Please obtain a local copy of NCBI CDD dastabase"
}
