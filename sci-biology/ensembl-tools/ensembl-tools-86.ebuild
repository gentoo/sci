# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module

DESCRIPTION="Variant Effect Predictor (VEP), AssemblyMapper, IDMapper, RegionReporter tools"
HOMEPAGE="http://www.ensembl.org/info/docs/tools/vep/script
	http://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html"
SRC_URI="https://github.com/Ensembl/ensembl-tools/archive/release/${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-perl/File-Copy-Recursive
	dev-perl/Archive-Extract
	dev-perl/Bio-DB-HTS
	dev-perl/Bio-EnsEMBL"
#DEPEND="dev-perl/Perl-XS
RDEPEND="${DEPEND}"

S="${WORKDIR}/ensembl-tools-release-${PV}"

src_install(){
	perl_set_version
	pushd scripts/variant_effect_predictor || die
	# BUG1: the INSTALL.pl does not exit upon error with non-zero exit code
	# BUG2: it complains if ${VENDOR_LIB}/${PN} is not in PERL5LIB
	# perl INSTALL.pl --AUTO=acf --NO_HTSLIB --PLUGINS all --DESTDIR ${VENDOR_LIB}/${PN} || die
	newdoc README.txt variant_effect_predictor.txt
	dobin variant_effect_predictor.pl gtf2vep.pl filter_vep.pl convert_cache.pl
	insinto /usr/share/"${PN}"/examples
	doins example_*
	popd
	pushd scripts/region_reporter || die
	dobin *.pl
	newdoc README.txt region_reporter.txt
	popd
	pushd scripts/assembly_converter
	dobin *.pl
	doins assemblymapper.in
	newdoc README.txt assembly_converter.txt
	popd
	pushd scripts/id_history_converter
	dobin *.pl
	newdoc README.txt id_history_converter.txt
	doins idmapper.in
	popd
}

pkg_postinst(){
	einfo "Probably you want to download some of the files from ftp://ftp.ensembl.org/pub/release-86/variation/VEP/"
}
# TODO The INSTALL.pl fetches https://raw.githubusercontent.com/Ensembl/VEP_plugins/release/86/plugin_config.txt
# and calls eval on its contents
