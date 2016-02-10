# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="r2cat and treecat, scaffolding tools for ordering and orienting contigs"
HOMEPAGE="http://bibiserv.techfak.uni-bielefeld.de/cgcat"
SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/cgcat/resources/downloads/r2cat.tar.gz"
# SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/cgcat/resources/downloads/r2cat.jar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jre-1.6:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/r2cat

src_prepare(){
	sed -e "s#/vol/bioapps#"${D}"/usr#" -e "s#/vol/bibidev/r2cat#"${D}"/usr#" -i Makefile
}

src_compile(){
	emake
}

src_install(){
	# emake install dies with:
	# jarsigner -tsa https://timestamp.geotrust.com/tsa -keystore /homes/phuseman/.gnupg/jarsigner_keystore_cg-cat  cg-cat.jar cgcat
	# Enter Passphrase for keystore: jarsigner: you must enter key password
	# Makefile:44: recipe for target 'cg-cat.jar' failed
	mkdir -p "${D}"/usr/share/r2cat
	emake install_cebitec
	emake install_bibiserv
}

# java -Xmx1024M -jar r2cat.jar
# java -Xmx1024M -cp r2cat.jar de.bielefeld.uni.cebitec.treecat.Treecat -Xmx -d64
