# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scaffold genome assemblies by Chromium/PacBio/Nanopore reads"
HOMEPAGE="https://github.com/bcgsc/LINKS"
SRC_URI="https://github.com/bcgsc/LINKS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RESTRICT="test"

RDEPEND="
	>=dev-lang/perl-1.6
	dev-lang/swig
	dev-util/cppcheck
"
#	sci-biology/btl_bloomfilter

src_compile(){
	cd btllib | die "Cannot chdir to bundled btllib/"
	./compile-wrappers || die "Failed to compile bundled btllib"
	# baah, this also does some kind of install
	# SUCCESS: sdsl was installed successfully!
	# The sdsl include files are located in $foo'/LINKS/btllib/external/sdsl-lite/installdir/include'.
	# The library files are located in $foo'/LINKS/btllib/external/sdsl-lite/installdir/lib'.
	#
	# Sample programs can be found in the examples-directory.
	# A program 'example.cpp' can be compiled with the command:
	# g++ -std=c++11 -DNDEBUG -O3 [-msse4.2] \
	#    -I$foo/LINKS/btllib/external/sdsl-lite/installdir/include -L$foo/LINKS/btllib/external/sdsl-lite/installdir/lib \
	#    example.cpp -lsdsl -ldivsufsort -ldivsufsort64
	#
	# Tests in the test-directory
	# A cheat sheet in the extras/cheatsheet-directory.
	# Have fun!
	# [2/3] Installing files.
	# Installing extras/python/_btllib.so to $foo/LINKS/btllib/python
	# Installing $foo/LINKS/btllib/extras/python/btllib.py to $foo/LINKS/btllib/python
}

src_install(){
	sed -e 's#$(bin)/../src/##' -i bin/LINKS-make || die
	sed -e 's#perl $(bin)/##' -i bin/LINKS-make || die
	dobin bin/LINKS bin/LINKS-make src/LINKS_CPP bin/*.pl tools/*.pl
	dodoc README.md
}
