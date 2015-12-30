# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-module

DESCRIPTION="A genome annotation viewer and pipeline for small eukaryota and prokaryota"
HOMEPAGE="http://www.yandell-lab.org/software/maker.html"
SRC_URI="maker-"${PV}".tgz"

RESTRICT="fetch"

# for academia: GPL-v2 or Artistic-2
# for commercial: ask
LICENSE="|| ( GPL-2 Artistic-2 )"
SLOT="0"
KEYWORDS=""
IUSE="mpi"

# http://search.cpan.org/~rybskej/forks-0.36/lib/forks.pm             # bug #566360
# http://search.cpan.org/~rybskej/forks-0.36/lib/forks/shared.pm
DEPEND="
	mpi? ( sys-cluster/mpich2 || ( sys-cluster/openmpi ) )
	dev-perl/DBI
	dev-perl/DBD-SQLite
	dev-perl/File-Which
	dev-perl/Bit-Vector
	dev-perl/Inline-C
	dev-perl/IO-All
	dev-perl/libwww-perl
	dev-perl/DBD-Pg
	dev-perl/Module-Build
	dev-perl/Want
	dev-perl/IO-Prompt
	dev-perl/Perl-Unsafe-Signals
	dev-perl/forks
	dev-perl/forks-shared
	>=sci-biology/bioperl-1.6
	sci-biology/ncbi-tools || ( sci-biology/ncbi-tools++ )
	sci-biology/snap
	sci-biology/exonerate
	sci-biology/augustus
	sci-biology/repeatmasker"
RDEPEND="${DEPEND}"

# ==============================================================================
# STATUS MAKER v2.31.8
# ==============================================================================
# PERL Dependencies:      MISSING
#                   !  Perl::Unsafe::Signals
#                   !  Want
#                   !  forks
#                   !  forks::shared
# 
# External Programs:      MISSING
#                   !  RepeatMasker
# 
# External C Libraries:   VERIFIED
# MPI SUPPORT:            DISABLED
# MWAS Web Interface:     DISABLED
# MAKER PACKAGE:          MISSING PREREQUISITES
# 
# 
# Important Commands:
#         ./Build installdeps     #installs missing PERL dependencies
#         ./Build installexes     #installs all missing external programs
#         ./Build install         #installs MAKER
#         ./Build status          #Shows this status menu
# 
# Other Commands:
#         ./Build repeatmasker    #installs RepeatMasker (asks for RepBase)
#         ./Build blast           #installs BLAST (NCBI BLAST+)
#         ./Build exonerate       #installs Exonerate (v2 on UNIX / v1 on Mac OSX)
#         ./Build snap            #installs SNAP
#         ./Build augustus        #installs Augustus
#         ./Build apollo          #installs Apollo
#         ./Build gbrowse         #installs GBrowse (must be root)
#         ./Build jbrowse         #installs JBrowse (MAKER copy, not web accecible)
#         ./Build webapollo       #installs WebApollo (use maker2wap to create DBs)
#         ./Build mpich2          #installs MPICH2 (but manual install recommended)
# Building MAKER
# 
# * MISSING MAKER PREREQUISITES - CANNOT CONTINUE!!

S="${WORKDIR}"/maker/src

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "maker-"${PV}".tgz and place it into ${DISTDIR}"
	einfo "You must also install sci-biology/repeatmasker otherwise"
	einfo "MAKER install process will stop."
	einfo "That in turn requires you to register at http://www.girinst.org/server/RepBase"
	einfo "to obtain sci-biology/repeatmasker-libraries data file"
	einfo "For execution through openmpi or mpich please read INSTALL file"
}

src_compile(){
	perl Build.PL || die
	./Build install || die
}

src_install(){
	cd "${WORKDIR}"/maker || die
	dobin bin/*
	dodoc README INSTALL
	insinto /usr/share/"{PN}"/GMOD/Apollo
	doins GMOD/Apollo/gff3.tiers
	insinto /usr/share/"{PN}"/GMOD/JBrowse
	doins GMOD/JBrowse/maker.css
}
