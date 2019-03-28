# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
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
#
# MAKER does not work with MVAPICH2.
# It can work with Intel MPI and OpenMPI with some command line modification.
# It always works with MPICH, but MPICH may not be able to scale to more than ~100 CPUs.
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
	>=sci-biology/GAL-0.2.1
	>=sci-biology/bioperl-1.6
	sci-biology/ncbi-tools || ( sci-biology/ncbi-tools++ )
	sci-biology/snap
	sci-biology/exonerate
	>=sci-biology/augustus-2.0
	sci-biology/repeatmasker"
	#sci-biology/GeneMark_ES-bin
	#sci-biology/GeneMark_S-bin
	#>=sci-biology/FGENESH-bin-2.4 (not in gentoo yet)
RDEPEND="${DEPEND}"
# dev-perl/forks-shared ?

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
	einfo "Customization typically go into maker_opts.ctl file"
}

src_compile(){
	perl Build.PL || die
	./Build install || die
	./Build installdeps || die
}

# If you move it, then the executables won't able to locate dependencies
# in the /maker/data, /maker/lib, /maker/perl directories. You should
# really either add the location of /maker/bin to you PATH environmental
# variable or at most soft link the executables somewhere
# else using the 'ln -s' command.
src_install(){
	cd "${WORKDIR}"/maker || die
	rm -f bin/fasta_tool # is part of sci-biology/GAL
	# drop development related accessory script requiring Parallel/MPIcar.pm
	find . -name mpi_evaluator | xargs rm || die
	mv bin/compare bin/compare_gff3_to_chado # rename as agreed by upstream, will be in maker-3 as well
	dobin bin/*
	perl_set_version
	insinto "${VENDOR_LIB}"/MAKER # uppercase, not "${PN}"
	doins perl/lib/MAKER/*.pm
	doman perl/man/*.3pm
	#
	# FIXME: find equivalent perl packages for lib/* contents, for example lib/GI.pm
	# You do not have write access to install missing Modules.
	# I can try and install these locally (i.e. only for MAKER)
	# in the .../maker/perl/lib directory, or you can run
	# './Build installdeps' as root or using sudo and try again.
	# Do want MAKER to try and build a local installation? [N ]N 
	# 
	# 
	# WARNING: You do not appear to have write access to install missing
	# Modules. Please run './Build installdeps' as root or using sudo.
	# 
	# Do you want to continue anyway? [N ]N 
	# 
	doins -r lib/*
	insinto "${VENDOR_LIB}"/Parallel/Application
	doins perl/lib/Parallel/Application/*.pm
	insinto /usr/share/"${PN}"/data
	doins data/*
	dodoc README INSTALL
	insinto /usr/share/"${PN}"/GMOD/Apollo
	doins GMOD/Apollo/gff3.tiers
	insinto /usr/share/"${PN}"/GMOD/JBrowse
	doins GMOD/JBrowse/maker.css
}
