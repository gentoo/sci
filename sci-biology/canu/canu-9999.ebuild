# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 git-r3

DESCRIPTION="Fork of a wgs-assembler for Oxfordnanopore and PacBio sequences"
HOMEPAGE="http://canu.readthedocs.io/en/latest"
EGIT_REPO_URI="https://github.com/marbl/canu.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

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
	"

# Perl 5.12.0, or File::Path 2.08
# Java SE 8
# https://github.com/marbl/MHAP uses Apache maven
S="${WORKDIR}"/"${P}"

# contains bundled mhap-2.1.3.jar, kmer, pbutgcns, FALCON

src_compile(){
	cd src || die
	emake
}

src_install(){
	# installs
	#  /usr/bin
	#  /usr/lib/libcanu.a
	#  /usr/lib/site_perl/canu
	#  /usr/share/java/classes/mhap-2.1.3.jar
	rm -rf Linux-amd64/obj
	insinto /usr
	doins -r Linux-amd64/{bin,lib,share}
}
