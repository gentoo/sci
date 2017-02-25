# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2

MY_PV=${PV/./_}

DESCRIPTION="SnpEff, SnpSift: Annotate SNP changes and predict effect in HGVS-compliant VCF"
HOMEPAGE="http://snpeff.sourceforge.net"
SRC_URI="
	http://sourceforge.net/projects/snpeff/files/snpEff_v${MY_PV}_core.zip
	http://snpeff.sourceforge.net/SnpSift.html -> ${P}.html"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# https://github.com/pcingola/SnpEff/blob/master/README_release.txt
RDEPEND="
	>=virtual/jre-1.7:*
	dev-java/maven-bin:*
	dev-java/antlr:*"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.7:*
	dev-java/ant-core"

S="${WORKDIR}"

#src_compile(){
#	mvn || die
#}

src_install(){
	cd .. || die
	mkdir -p "${ED}"/usr/share || die
	# but portage does not install the .* files and subdirs, grr!
	unzip \
		"${DISTDIR}"/snpEff_v"${MY_PV}"_core.zip -d "${ED}"/usr/share \
		|| die "failed to unzip ${DISTDIR}/snpEff_v${MY_PV}_core.zip"
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
