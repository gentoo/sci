# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="EST assembly and annotation pipeline for chado/gbrowse2 display"
HOMEPAGE="http://code.google.com/p/est2assembly/"
ESVN_REPO_URI="http://est2assembly.googlecode.com/svn/trunk"

if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="http://est2assembly.googlecode.com/svn/trunk"
	KEYWORDS=""
else
	SRC_URI="http://est2assembly.googlecode.com/files/est2assembly_"${PV}".tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

# still missing
# annot8r  http://nematodes.org/bioinformatics/annot8r/index.shtml and http://nematodes.org/bioinformatics/Annot8r_physprop/
# prot4EST http://nematodes.org/bioinformatics/prot4EST/

DEPEND="
	app-arch/pbzip2
	dev-lang/perl
	dev-perl/Time-Progress
	sci-biology/fasta
	sci-biology/ssaha2-bin
	sci-biology/mira
	sci-biology/emboss
	sci-biology/bioperl"
RDEPEND="${DEPEND}"

# more install tricks in "${S}"/install.pl

pkg_postinst(){
	einfo "The package uses mira and newbler assemblers"
}
