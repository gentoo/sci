# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils java-pkg-2 perl-module multilib git-r3

DESCRIPTION="Fork of a wgs-assembler for Oxfordnanopore and PacBio sequences"
HOMEPAGE="http://canu.readthedocs.io/en/latest"
EGIT_REPO_URI="https://github.com/marbl/canu.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=virtual/jre-1.8:*
	dev-lang/perl
	virtual/perl-File-Path
	sci-visualization/gnuplot
	"
# =sci-biology/mhap-2.1.3 if we unbundle it
DEPEND="${RDEPEND}
	>=virtual/jdk-1.8:*
	dev-java/ant-core
	!sci-biology/wgs-assembler
	"

# Detected file collision(s):
#  * sci-biology/wgs-assembler-8.3_rc2:0::science
#  * 	/usr/bin/bogart
#  * 	/usr/bin/bogus
#  * 	/usr/bin/fastqAnalyze
#  * 	/usr/bin/fastqSample
#  * 	/usr/bin/fastqSimulate
#  * 	/usr/bin/fastqSimulate-sort
#  * 	/usr/bin/meryl
#  * 	/usr/bin/overlapInCore
#  * 	/usr/bin/utgcns

# Perl 5.12.0, or File::Path 2.08
# Java SE 8
# https://github.com/marbl/MHAP uses Apache maven
S="${WORKDIR}"/"${P}"

# contains bundled mhap-2.1.3.jar, kmer, pbutgcns, FALCON

src_prepare(){
	epatch "${FILESDIR}"/canu-1.8_respect_CXXFLAGS.patch
}

src_compile(){
	cd src || die
	emake
}

src_install(){
	# installs
	#  /usr/bin
	#  /usr/lib/libcanu.a
	#  /usr/lib64/perl5/vendor_perl/5.28.0/lib/site_perl/canu
	#  /usr/share/java/classes/mhap-2.1.3.jar
	rm -rf Linux-amd64/obj
	insinto /usr
	doins -r Linux-amd64/{bin,share}
	insinto /usr/$(get_libdir)
	dolib Linux-amd64/lib/libcanu.a
	rm Linux-amd64/lib/libcanu.a || die
	perl_set_version
	insinto ${VENDOR_LIB}
	doins -r Linux-amd64/lib
}
