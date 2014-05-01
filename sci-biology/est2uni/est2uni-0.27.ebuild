# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils perl-module webapp

DESCRIPTION="Perl-based analysis pipeline including php-based web interface"
HOMEPAGE="http://cichlid.umd.edu/est2uni/download.php"
SRC_URI="
	http://cichlid.umd.edu/est2uni/est2uni_0.27.tar.gz
	ftp://ftp.ncbi.nih.gov/pub/UniVec/UniVec
	ftp://ftp.ncbi.nih.gov/pub/UniVec/UniVec_Core
	http://www.geneontology.org/ontology/gene_ontology.obo
	http://www.geneontology.org/doc/GO.terms_and_ids"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-db/mysql-4.1
	dev-lang/php:5.3
	dev-perl/go-perl
	sci-biology/bioperl
	sci-biology/cap3-bin
	sci-biology/estscan
	sci-biology/exonerate
	<sci-biology/hmmer-3.0
	sci-biology/lucy
	sci-biology/ncbi-tools
	sci-biology/phred
	sci-biology/repeatmasker
	sci-biology/seqclean
	sci-biology/tgicl
	www-servers/apache"

S="${WORKDIR}"/est2uni

src_prepare(){
	for f in "${FILESDIR}"/*.pm.patch "${FILESDIR}"/tgicl_files.patch; do
		cd perl; epatch $f
	done
}

src_compile(){
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} external_software/sputnik/sputnik.c -o external_software/sputnik/sputnik || die
}

src_install(){
	mkdir -p "${D}"/opt/est2uni
	mv external_software/sputnik/sputnik "${D}"/opt/est2uni || die

	chmod a+rx perl/*.pl perl/*.pm || die
	mv perl/* "${D}"/opt/est2uni || die

	doenvd "${FILESDIR}"/99est2uni

	mkdir -p "${D}"/usr/share/webapps/"${PN}"/"${PV}"/htdocs
	cp -r php/* "${D}"/usr/share/webapps/"${PN}"/"${PV}"/htdocs || die

	mkdir -p "${D}"/opt/est2uni/test_data || die
	mv test_data/* "${D}"/opt/est2uni/test_data || die
	# mkdir -p "${D}"/usr/share/"${PN}" || die
	# mv test_data "${D}"/usr/share/"${PN}" || die
	perl-module_src_install || die

	webapp_src_preinst
	webapp_postinst_txt en "${S}"/README
	webapp_src_install

	# cp "${DISTDIR}"/UniVec_Core "${DISTDIR}"/UniVec "${D}"/usr/share/ncbi/data/ || die

	einfo "Please follow the pipeline installation and web configuration docs at"
	einfo "http://cichlid.umd.edu/est2uni/install.php"
	einfo "BEWARE the software is not maintained anymore by upstream but I do not"
	einfo "know any better available (replaced by ngs_backbone which has no web"
	einfo "interface yet). Consider using latest svn checkout instead of 0.27"
	einfo "release from 2007 or so."
	einfo "Possible fixes and stuff to read:"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-January/000069.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-March/000103.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-March/000101.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000135.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000131.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-February/000070.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000129.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000128.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-May/000139.html"
	echo ""
	einfo "Current code is at http://bioinf.comav.upv.es/git///?p=est2uni;a=summary"
}

pkg_postinst(){
	webapp_pkg_postinst
}
