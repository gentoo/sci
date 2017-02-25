# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="EST assembly and annotation pipeline for chado/gbrowse2 display"
HOMEPAGE="http://code.google.com/p/est2assembly/"
SRC_URI="http://est2assembly.googlecode.com/files/est2assembly_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-arch/pbzip2
	app-portage/g-cpan
	dev-lang/perl
	dev-perl/Time-Progress
	sci-biology/fasta
	sci-biology/ssaha2-bin
	sci-biology/mira
	sci-biology/emboss
	sci-biology/bioperl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"
