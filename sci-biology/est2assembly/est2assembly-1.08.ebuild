# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="EST assembly and annotation pipeline for chado/gbrowse2 display"
HOMEPAGE="http://code.google.com/p/est2assembly/"
SRC_URI="http://est2assembly.googlecode.com/files/est2assembly_1.08.tar.gz"

LICENSE="GPL-v3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
		app-portage/g-cpan
		perl-gcpan/Time-Progress
		sci-biology/fasta
		sci-biology/ssaha2
		sci-biology/mira
		sci-biology/emboss
		sci-biology/bioperl
		app-arch/pbzip2"
RDEPEND="${DEPEND}"

