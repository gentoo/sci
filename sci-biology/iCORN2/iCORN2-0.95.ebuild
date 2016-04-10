# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Iteratively map reads to a reference, fix mismatches and indels with GATK/picard"
HOMEPAGE="http://icorn.sourceforge.net/
		http://sourceforge.net/projects/icorn"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/pagit/ICORN2/icorn2.V${PV}.tgz
	http://icorn.sourceforge.net/manual.html -> ${PN}_manual.html"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sci-biology/snpomatic
	|| ( sci-biology/smalt sci-biology/smalt-bin )
	sci-biology/samtools:=
	sci-biology/gatk
	sci-biology/picard"
RDEPEND="${DEPEND}
	dev-lang/perl
	app-shells/tcsh"

S="${WORKDIR}"/ICORN2

src_unpack(){
	default
	# The bundled files GenomeAnalysisTK.jar from GATK
	# contains bundled MarkDuplicates.jar from picard
	# both .jar files were supposed to be in $ICORN2_HOME
	rm -f *~ smalt || die
}

src_prepare(){
	sed -e "s#java -jar \$ICORN2_HOME#java -jar /usr/share/${PN}/lib#" -i *.sh || die
}

# the tarball is a terrible mess
src_install(){
	dobin *.pl *.sh
	insinto /usr/share/"${PN}"/lib
	doins GenomeAnalysisTK.jar MarkDuplicates.jar
	insinto /usr/share/"${PN}"/LSF
	doins LSF/*
	dodoc README.txt
	newdoc "${DISTDIR}"/"${PN}"_manual.html manual.html
}

# http://icorn.sourceforge.net/documentation.html
# Define the shell variable ICORN_HOME, PILEUP_HOME and SNPOMATIC_HOME
pkg_postinst(){
	einfo "Ideally install Artemis ACT viewer or gap4 from staden package"
}
