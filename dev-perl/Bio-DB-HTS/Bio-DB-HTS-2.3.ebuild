# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# this is https://metacpan.org/pod/Bio::DB::HTS and https://github.com/Ensembl/Bio-DB-HTS
# this is not https://metacpan.org/pod/Bio::HTS
MODULE_AUTHOR="RISHIDEV"
inherit perl-module multilib toolchain-funcs

DESCRIPTION="Enable rapid access to bgzipped FASTA files"

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	sci-libs/htslib[static-libs]"

SRC_TEST="do"

src_prepare(){
	# https://github.com/Ensembl/Bio-HTS/issues/30
	export HTSLIB_LIBDIR="${EPREFIX}"/"$(get_libdir)" # currently ignored
	export HTSLIB_INCDIR="${EPREFIX}"/usr/include/htslib # currently ignored
	export HTSLIB_DIR="${EPREFIX}"/usr # useless, Build.PL will not invent /usr/lib64/ is the correct answer
	perl-module_src_prepare
}

# is the below -rpath acceptable?
# x86_64-pc-linux-gnu-gcc -shared -O2 -pipe -maes -mpclmul -mpopcnt -mavx -march=native -Wl,-O1 -Wl,--as-needed -o blib/arch/auto/Bio/DB/HTS/HTS.so lib/Bio/DB/HTS.o -L/usr/lib -Wl,-rpath,/usr/lib -lhts -lpthread -lz
# x86_64-pc-linux-gnu-gcc -shared -O2 -pipe -maes -mpclmul -mpopcnt -mavx -march=native -Wl,-O1 -Wl,--as-needed -o blib/arch/auto/Bio/DB/HTS/Faidx/Faidx.so lib/Bio/DB/HTS/Faidx.o -L/usr/lib -Wl,-rpath,/usr/lib -lhts -lpthread -lz
