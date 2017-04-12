# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="Bayesian gen. variant detector to find short polymorphisms"
HOMEPAGE="https://github.com/ekg/freebayes"
EGIT_REPO_URI="https://github.com/ekg/freebayes.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="dev-util/cmake"
DEPEND=""
RDEPEND="${DEPEND}
	sci-libs/htslib
	sci-biology/bamtools
	sci-biology/samtools:*"

# $ git clone --recursive git://github.com/ekg/freebayes.git
# Cloning into 'freebayes'...
# remote: Counting objects: 4942, done.
# remote: Total 4942 (delta 0), reused 0 (delta 0), pack-reused 4942
# Receiving objects: 100% (4942/4942), 5.93 MiB | 1.13 MiB/s, done.
# Resolving deltas: 100% (3274/3274), done.
# Submodule 'SeqLib' (https://github.com/walaj/SeqLib.git) registered for path 'SeqLib'
# Submodule 'bamtools' (https://github.com/ekg/bamtools.git) registered for path 'bamtools'
# Submodule 'intervaltree' (https://github.com/ekg/intervaltree.git) registered for path 'intervaltree'
# Submodule 'bash-tap' (https://github.com/illusori/bash-tap.git) registered for path 'test/bash-tap'
# Submodule 'test/test-simple-bash' (https://github.com/ingydotnet/test-simple-bash.git) registered for path 'test/test-simple-bash'
# Submodule 'vcflib' (https://github.com/vcflib/vcflib.git) registered for path 'vcflib'
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/SeqLib'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/bamtools'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/intervaltree'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/test/bash-tap'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/test/test-simple-bash'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib'...
# Submodule path 'SeqLib': checked out 'cce1e410ef6d2ac64972f5cacd8a0f9b86cecdd8'
# Submodule 'bwa' (https://github.com/jwalabroad/bwa) registered for path 'SeqLib/bwa'
# Submodule 'fermi-lite' (https://github.com/jwalabroad/fermi-lite) registered for path 'SeqLib/fermi-lite'
# Submodule 'htslib' (https://github.com/samtools/htslib) registered for path 'SeqLib/htslib'
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/SeqLib/bwa'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/SeqLib/fermi-lite'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/SeqLib/htslib'...
# Submodule path 'SeqLib/bwa': checked out 'fbd4dbc03904eccd71cdca8cac7aa48da749c19c'
# Submodule path 'SeqLib/fermi-lite': checked out '5bc90f8d70e2b66184eccbd223a3be714c914365'
# Submodule path 'SeqLib/htslib': checked out '0f298ce22c5c825c506129bf242348a31630c382'
# Submodule path 'bamtools': checked out 'e77a43f5097ea7eee432ee765049c6b246d49baa'
# Submodule path 'intervaltree': checked out 'dbb4c513d1ad3baac516fc1484c995daf9b42838'
# Submodule path 'test/bash-tap': checked out 'c38fbfa401600cc81ccda66bfc0da3ea56288d03'
# Submodule path 'test/test-simple-bash': checked out '124673ff204b01c8e96b7fc9f9b32ee35d898acc'
# Submodule path 'vcflib': checked out '5e3ce04f758c6df16bc4d242b18a24d725d2e6e5'
# Submodule 'fastahack' (https://github.com/ekg/fastahack.git) registered for path 'vcflib/fastahack'
# Submodule 'filevercmp' (https://github.com/ekg/filevercmp.git) registered for path 'vcflib/filevercmp'
# Submodule 'fsom' (https://github.com/ekg/fsom.git) registered for path 'vcflib/fsom'
# Submodule 'googletest' (https://github.com/google/googletest.git) registered for path 'vcflib/googletest'
# Submodule 'intervaltree' (https://github.com/ekg/intervaltree.git) registered for path 'vcflib/intervaltree'
# Submodule 'multichoose' (https://github.com/ekg/multichoose.git) registered for path 'vcflib/multichoose'
# Submodule 'smithwaterman' (https://github.com/ekg/smithwaterman.git) registered for path 'vcflib/smithwaterman'
# Submodule 'tabixpp' (https://github.com/ekg/tabixpp.git) registered for path 'vcflib/tabixpp'
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/fastahack'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/filevercmp'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/fsom'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/googletest'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/intervaltree'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/multichoose'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/smithwaterman'...
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/tabixpp'...
# Submodule path 'vcflib/fastahack': checked out 'c68cebb4f2e5d5d2b70cf08fbdf1944e9ab2c2dd'
# Submodule path 'vcflib/filevercmp': checked out '1a9b779b93d0b244040274794d402106907b71b7'
# Submodule path 'vcflib/fsom': checked out 'a6ef318fbd347c53189384aef7f670c0e6ce89a3'
# Submodule path 'vcflib/googletest': checked out 'd225acc90bc3a8c420a9bcd1f033033c1ccd7fe0'
# Submodule path 'vcflib/intervaltree': checked out 'b704f195e9b51d44dad68e33c209b06e63ebb353'
# Submodule path 'vcflib/multichoose': checked out '73d35daa18bf35729b9ba758041a9247a72484a5'
# Submodule path 'vcflib/smithwaterman': checked out '84c08d7eae7211d87fbcb1871dae20e6c2041e96'
# Submodule path 'vcflib/tabixpp': checked out '80012f86dc22b13c75b73baf38195956db92473e'
# Submodule 'htslib' (https://github.com/samtools/htslib.git) registered for path 'vcflib/tabixpp/htslib'
# Cloning into '/home/mmokrejs/proj/sci/sci-biology/freebayes/a/freebayes/vcflib/tabixpp/htslib'...
# Submodule path 'vcflib/tabixpp/htslib': checked out '0f298ce22c5c825c506129bf242348a31630c382'

# g++ -O3 -D_FILE_OFFSET_BITS=64 -g -I../ttmath -I../bamtools/src/ -I../vcflib/src/ -I../vcflib/tabixpp/ -I../vcflib/smithwaterman/ -I../vcflib/multichoose/ -I../vcflib/filevercmp/ -I../vcflib/tabixpp/htslib -I../SeqLib -I../SeqLib/htslib -c freebayes.cpp

src_prepare(){
	find . -name Makefile | while read f; do \
		sed -e "s/-O3 -D_FILE_OFFSET_BITS=64/${CFLAGS}/" -i $f || die
		sed -e "s/^CFLAGS:= -O3/CFLAGS ?= ${CFLAGS}/" -i $f || die
		sed -e "s/^CXX = g++/CXX = $(tc-getCXX)/;s/^CXX=g++/CXX = $(tc-getCXX)/" -i $f || die
		sed -e "s/g++ /$(tc-getCXX) /" -i $f || die
		sed -e "s/-O3/${CXXFLAGS}/" -i $f || die
		sed -e "s/^CC[ 	]*=[ 	]gcc/CC = $(tc-getCC)/" -i $f || die
		sed -e "s/-g -Wall -O2/${CFLAGS}/;s/-g -Wall -Wno-unused-function -O2/${CFLAGS}/" -i $f || die
		sed -e "s/-O3 /${CFLAGS}/;s/ -O3/${CFLAGS}/" -i $f || die
	done
	sed -e "s/^C=gcc/C = $(tc-getCC)/" -i Makefile || die
	sed -e "s/gcc/$(tc-getCC)/" -i SeqLib/bwa/Makefile SeqLib/fermi-lite/Makefile || die
	sed -e "s/g++/$(tc-getCXX)/" -i SeqLib/src/Makefile.am || die
	default
}

src_compile(){
	emake -j1 # vcflib/smithwaterman/ sometimes does not compile
}

src_install(){
	dobin bin/freebayes bin/bamleftalign
}
