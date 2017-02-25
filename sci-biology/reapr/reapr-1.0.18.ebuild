# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Verify and correct genome assembly scaffolds using paired-end reads"
HOMEPAGE="http://www.sanger.ac.uk/science/tools/reapr"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_${PV}.tar.gz
	ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.18.manual.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# tested smalt versions 0.6.4 to 0.7.0.1 only
DEPEND="sci-biology/bamtools
	=sci-biology/samtools-0.1.19-r2" # actually bundled is 0.1.18
RDEPEND="${DEPEND}"
#	sci-biology/smalt
#	dev-perl/File-Basename
#	dev-perl/File-Copy
#	dev-perl/File-Spec
#	perl-core/Getopt-Long
#	dev-perl/List-Util
#	dev-lang/R"

S="${WORKDIR}"/Reapr_"${PV}"

# we use temporarily patches from https://anonscm.debian.org/cgit/debian-med/reapr.git/tree/debian/patches

src_prepare(){
	default
	for f in "${FILESDIR}"/*.patch; do epatch $f || die; done
	sed -e 's#^CC = g++#CXX ?= g++#' -i src/Makefile || die
	sed -e 's#$(CC)#$(CXX)#' -i src/Makefile || die
	sed -e 's#-O3##' -i src/Makefile || die
	sed -e 's#^CFLAGS =#CXXFLAGS += -I../third_party/tabix -L../third_party/tabix -I../third_party/bamtools/src -L../third_party/bamtools/src#' -i src/Makefile || die
	#sed -e 's#-lbamtools#../third_party/bamtools/src/libbamtools.so#' -i src/Makefile || die
	sed -e 's#-ltabix#../third_party/tabix/libtabix.a#' -i src/Makefile || die
	sed -e 's#CFLAGS#CXXFLAGS#' -i src/Makefile || die
}

src_compile(){
	cd third_party/tabix || die
	emake # to yield tabix.o object
	cd ../.. || die
	cd src || die
	emake # link directly tabix.o but elsewhere also ../third_party/tabix/libtabix.a
}

src_install(){
	dodoc "${DISTDIR}"/Reapr_"${PV}".manual.pdf
}

pkg_postinst(){
	einfo "There are test data at ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_${PV}.test_data.tar.gz"
	einfo "You can view results with >=sci-biology/artemis*-15.0.0"
}
