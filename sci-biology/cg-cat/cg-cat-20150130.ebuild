# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="r2cat and treecat, scaffolding tools for ordering and orienting contigs"
HOMEPAGE="http://bibiserv.techfak.uni-bielefeld.de/cgcat"
SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/cgcat/resources/downloads/r2cat.tar.gz"
# SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/cgcat/resources/downloads/r2cat.jar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${DEPEND}
	>=virtual/jre-1.6:*
	dev-lang/perl
	sci-biology/ncbi-tools"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.6:*
	dev-java/ant-core"

S="${WORKDIR}"/r2cat

src_prepare(){
	sed -e "s#/vol/bioapps#"${D}"/usr#" -e "s#/vol/bibidev/r2cat#"${D}"/usr#" -i Makefile || die
	sed -e "s#/vol/gnu#/usr#" -i de/bielefeld/uni/cebitec/r2cat/blast_to_r2cat.pl || die
}

src_compile(){
	emake r2cat.jar
}

src_install(){
	# emake install dies with:
	# jarsigner -tsa https://timestamp.geotrust.com/tsa -keystore /homes/phuseman/.gnupg/jarsigner_keystore_cg-cat  cg-cat.jar cgcat
	# Enter Passphrase for keystore: jarsigner: you must enter key password
	# Makefile:44: recipe for target 'cg-cat.jar' failed
	mkdir -p "${D}"/usr/share/r2cat
	# emake install_cebitec
	# emake install_bibiserv
	# the blast_to_r2cat.pl script needs bioperl
	dobin de/bielefeld/uni/cebitec/r2cat/blast_to_r2cat.pl
	java-pkg_dojar r2cat.jar || die
	dodoc README.md ReadmeLicenses.txt
	insinto /usr/share/doc/"${PN}"/html
	doins de/bielefeld/uni/cebitec/r2cat/help/*
}

# to start r2cat:
# java -Xmx10240M -jar r2cat.jar de.bielefeld.uni.cebitec.r2cat.R2cat

# to start treecat:
# java -Xmx10240M -cp r2cat.jar de.bielefeld.uni.cebitec.treecat.Treecat -Xmx -d64

# add -d64 on the java commandline if you need more than 4GB of memory and your system can handle it
