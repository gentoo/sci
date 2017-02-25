# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="In-memory K-mer counting in DNA/RNA/protein sequences"
HOMEPAGE="https://github.com/ged-lab/khmer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="sci-biology/screed"

python_prepare_all(){
	rm -rf lib/{bzip2,zlib} || die

	sed \
		-e 's:zlib/zlib.h:zlib.h:g' \
		-e 's:bzip2/bzlib.h:bzlib.h:g' \
		-i lib/read_parsers.hh lib/counting.cc || die

	sed \
		-e "/^EXTRA_COMPILE_ARGS/s:=.*:=[]:g" \
		-i setup.py || die

	cat > setup.cfg <<- EOF
	[nosetests]
	verbosity = 2
	stop = TRUE
	attr = !known_failing

	[build_ext]
	undef = NO_UNIQUE_RC
	libraries = z,bz2
	## if using system libraries
	include-dirs = lib:lib/zlib:lib/bzip2
	# include-dirs = lib
	## if using system libraries (broken)

	define = NDEBUG
	# is not needed for most Linux installs
	# see the OPT line in /usr/lib/python2.7/config/Makefile which gets included
	# in distutils version of CFLAGS

	[easy_install]

	EOF

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py nosetests || die
}
