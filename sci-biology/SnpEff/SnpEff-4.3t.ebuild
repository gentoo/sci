# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="SnpEff, SnpSift: Annotate SNP changes and predict effect in HGVS-compliant VCF"
HOMEPAGE="https://pcingola.github.io/SnpEff/"
SRC_URI="
	https://downloads.sourceforge.net/project/snpeff/snpEff_v${PV//./_}_core.zip
"

S="${WORKDIR}"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.7:*
	dev-java/maven-bin:*
	dev-java/antlr:*"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.7:*
"
BDEPEND="app-arch/unzip"

src_install(){
	cd .. || die
	mkdir -p "${ED}"/usr/share || die
	# but portage does not install the .* files and subdirs, grr!
	unzip \
		"${DISTDIR}"/snpEff_v"${PV//./_}"_core.zip -d "${ED}"/usr/share \
		|| die "failed to unzip ${DISTDIR}/snpEff_v${PV//./_}_core.zip"
	sed \
		-e "s#$HOME/tools/picard/#${ED}/usr/share/picard/lib/#" \
		-i "${ED}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
	sed \
		-e "s#$HOME/tools/gatk/#${ED}/usr/share/gatk/lib/#" \
		-i "${ED}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
	sed \
		-e "s#$HOME/snpEff/#${ED}/usr/share/snpEff/#" \
		-i "${ED}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
	sed \
	-e "s#$HOME/snpEff/snpEff.config#${ED}/usr/share/snpEff/snpEff.config#" \
	-i "${ED}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
}

# now fetch the version-specific databases from http://sourceforge.net/projects/snpeff/files/databases/v4_1/
# it also automagically fetches them but into /tmp/ unlike $CWD
#
# java -Xmx4g path/to/snpEff/snpEff.jar -c path/to/snpEff/snpEff.config GRCh37.75 path/to/snps.vcf
#
# It is best to just unpack the tarball locally and not use portage at all.
