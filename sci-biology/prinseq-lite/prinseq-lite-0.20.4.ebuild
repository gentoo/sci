# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Describe, trim, reformat and convert to or form FASTA/FASTQ files"
HOMEPAGE="http://prinseq.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/prinseq/files/standalone/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/perl-Getopt-Long
	virtual/perl-File-Temp
	virtual/perl-MIME-Base64
	dev-perl/Digest-MD5-File
	dev-perl/JSON
	dev-perl/Cairo"
# Cwd
# Pod::Usage
# Fcntl qw(:flock SEEK_END)
# List::Util qw(sum min max)

# prinseq-graphs.pl needs in addition
# https://sourceforge.net/projects/prinseq/files/README.txt
# Statistics::PCA

src_install(){
	dobin *.pl
	dodoc README
}
