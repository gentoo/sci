# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 java-ant-2

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Annotate SNP changes and predict their effect"
HOMEPAGE="http://snpeff.sourceforge.net"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/pcingola/SnpEff.git"
	#EGIT_BRANCH="v4.1B"
	KEYWORDS=""
else
	SRC_URI="http://sourceforge.net/projects/snpeff/files/snpEff_v4_1e_core.zip
			http://snpeff.sourceforge.net/SnpSift.html -> ${P}.html"
	KEYWORDS="~amd64"
	S="${WORKDIR}"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

# https://github.com/pcingola/SnpEff/blob/master/README_release.txt
DEPEND=">=virtual/jre-1.7:*
	dev-java/maven-bin:*
	dev-java/antlr:*"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"

#src_compile(){
#	mvn || die
#}

src_install(){
	cd .. || die
	mkdir -p "${D}"/usr/share
	# but portage does not install the .* files and subdirs, grr!
	unzip "${DISTDIR}"/snpEff_v4_1e_core.zip -d "${D}"/usr/share || die "failed to unzip ${DISTDIR}/snpEff_v4_1e_core.zip"
	sed -e 's#$HOME/tools/picard/#/usr/share/picard/lib/#' -i "${D}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
	sed -e 's#$HOME/tools/gatk/#/usr/share/gatk/lib/#' -i "${D}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
	sed -e 's#$HOME/snpEff/#/usr/share/snpEff/#' -i "${D}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
	sed -e 's#$HOME/snpEff/snpEff.config#/usr/share/snpEff/snpEff.config#' -i "${D}"/usr/share/snpEff/scripts/annotate_demo_GATK.sh || die
}

# now fetch the version-specific databases from http://sourceforge.net/projects/snpeff/files/databases/v4_1/
# it also automagically fetches them but into /tmp/ unlike $CWD
#
# java -Xmx4g path/to/snpEff/snpEff.jar -c path/to/snpEff/snpEff.config GRCh37.75 path/to/snps.vcf
#
# It is best to just unpack the tarball locally and not use portage at all.
