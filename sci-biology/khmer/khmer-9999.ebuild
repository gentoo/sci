# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="In-memory K-mer counting in DNA/RNA/protein sequences"
HOMEPAGE="https://github.com/ged-lab/khmer"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/ged-lab/khmer"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="sci-biology/screed"

#python_prepare_all(){
#	rm -rf lib/{bzip2,zlib} || die
#
#	sed \
#		-e 's:zlib/zlib.h:zlib.h:g' \
#		-e 's:bzip2/bzlib.h:bzlib.h:g' \
#		-i lib/read_parsers.hh lib/counting.cc || die
#
#	sed \
#		-e "/extra_objects/d" \
#		-e "s:'nose >= 1.0', ::g" \
#		-e "s:'sphinx',::g" \
#		-e '/libraries/s:, ]:, "z", "bz2", ]:g' \
#		-e "s:'-O3',::g" \
#		-i setup.py || die
#
#	distutils-r1_python_prepare_all
#}

# setup.py --libraries z,bz2 || die
