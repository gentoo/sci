# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit toolchain-funcs autotools-utils

DESCRIPTION="C/C++ library for working with human genetic variation data"
HOMEPAGE="http://atgu.mgh.harvard.edu/plinkseq"
SRC_URI="http://psychgen.u.hpc.mssm.edu/plinkseq_downloads/plinkseq-src-latest.tgz -> ${P}.tgz"
# https://bitbucket.org/statgen/plinkseq.git
# http://pngu.mgh.harvard.edu/~purcell/plink/download.shtml

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-libs/zlib
	dev-libs/protobuf
	!sci-biology/fsl" # file collision on /usr/bin/mm
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s/gcc/$(tc-getCC)/g;s/g++/$(tc-getCXX)/g;s/-O3/${CFLAGS}/g" -i config_defs.Makefile || die
	sed -e "s/= -static/=/g" -i config_defs.Makefile || die
	rm -rf sources/ext/protobuf-* || die
	rm sources/ext/protobuf sources/ext/sources/include/google || die
	rm -rf sources/mongoose || die
	sed -e 's@^all:.*@all: # skipping compilation of bundled dev-libs/protobuf@' -i sources/ext/Makefile || die
	# TODO: fix also sources/ext/sources/include/DUMMY/include/google/protobuf/compiler/plugin.proto causing:
	# plugin.proto: Import "google/protobuf/descriptor.proto" was not found or had errors.
	# plugin.proto:74:12: "FileDescriptorProto" is not defined.
	find . -name \*.proto | while read f; do \
		d=`dirname $f`; \
		pushd $d; \
		protoc --cpp_out=. *.proto || exit 255; \
		popd; \
	done || die
	autotools-utils_src_prepare
}

src_install(){
	cd build/execs || die
	# TODO: avoid file collision with sci-biology/fsl
	# https://bitbucket.org/statgen/plinkseq/issue/9/rename-mm-filename-to-plinkseq_mm
	# TODO: avoid file collision with www-servers/mongoose
	dobin gcol browser pseq behead mm smp tab2vcf pdas
}
