# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit toolchain-funcs git-r3

DESCRIPTION="C/C++ library for working with human genetic variation data"
HOMEPAGE="http://atgu.mgh.harvard.edu/plinkseq"
EGIT_REPO_URI="https://bitbucket.org/statgen/plinkseq.git"
# https://bitbucket.org/statgen/plinkseq/commits/all
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
	# we cannot zap calls to bundled mongoose because www-servers/mongoose does not build a library at all
	# rm -rf sources/mongoose || die
	# sed -e "s@$(MONGOOSE_LIB_DIR) @@;s@$(MONGOOSE_INC) @@;s@$(MONGOOSE_LIB_BASE_DIR) @@" - Makefile || die
	sed -e 's@^all:.*@all: # skipping compilation of bundled dev-libs/protobuf@' -i sources/ext/Makefile || die
	find . -name \*.proto | while read f; do \
		d=`dirname $f`; \
		pushd $d; \
		protoc --cpp_out=. *.proto || exit 255; \
		popd; \
	done || die
	#
	# recopy the updated files
	cp -p sources/plinkseq/sources/lib/matrix.pb.h sources/plinkseq/sources/include/plinkseq/matrix.pb.h || die
	cp -p sources/plinkseq/sources/lib/variant.pb.h sources/plinkseq/sources/include/plinkseq/variant.pb.h || die
	sed -e 's/google::protobuf::internal::kEmptyString/google::protobuf::internal::GetEmptyStringAlreadyInited()/g' -i sources/plinkseq/sources/lib/matrix.pb.cpp || die
	sed -e 's/google::protobuf::internal::kEmptyString/google::protobuf::internal::GetEmptyStringAlreadyInited()/g' -i sources/plinkseq/sources/lib/variant.pb.cpp || die
	local myinc=`pkg-config protobuf --variable=includedir`
	sed -e 's@$(PROTOBUF_LIB_BASE_DIR)/$(INC_DIR)/@'"${myinc}@" -i Makefile || die
	local mylib=`pkg-config protobuf --variable=libdir`
	sed -e 's@$(PROTOBUF_LIB_BASE_DIR)/$(BLD_LIB_DIR)/@'"-L${mylib} @" -i Makefile || die # note the trailing space as it get prepended to PROTOBUF_LIBS
	# anyway $(PROTOBUF_LIB_FULL_PATH) is a necessary build target, just drop it
	sed -e 's@^PROTOBUF_LIB_FULL_PATH =.*/@PROTOBUF_LIB_FULL_PATH =@' -i Makefile || die
	local mylibs=`pkg-config protobuf --libs`
	sed -e "s@libprotobuf.a@ ${mylibs}@ " -i Makefile || die
}

src_install(){
	cd build/execs || die
	# TODO: avoid file collision with sci-biology/fsl
	# https://bitbucket.org/statgen/plinkseq/issue/9/rename-mm-filename-to-plinkseq_mm
	# TODO: avoid file collision with www-servers/mongoose
	dobin gcol browser pseq behead mm smp tab2vcf pdas
}
