# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Whole genome shotgun assembler (sparse de Bruijn graph) (now MEGAHIT)"
HOMEPAGE="https://github.com/aquaskyline/SOAPdenovo2
	https://gigascience.biomedcentral.com/articles/10.1186/2047-217X-1-18"
SRC_URI="https://github.com/aquaskyline/SOAPdenovo2/archive/r${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="" # fails to compile

DEPEND="dev-libs/libaio
	sci-biology/samtools:0.1-legacy"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-r"${PV}" # version is 2.04-r241

src_prepare(){
	#eapply "${FILESDIR}"/SOAPdenovo2-r241-Makefile.patch
	# this will be partly covered by
	# https://github.com/aquaskyline/SOAPdenovo2/pull/44
	#
	for f in Makefile standardPregraph/Makefile sparsePregraph/Makefile; do
		sed -e 's#^INCLUDES =#INCLUDES = -I/usr/include/bam-0.1-legacy -I./inc#;s#-lbam#-lbam-0.1-legacy#' -i $f || die
	done
	rm -f standardPregraph/*.a standardPregraph/inc/sam.h standardPregraph/inc/bam.h standardPregraph/inc/bgzf.h \
		sparsePregraph/inc/sam.h sparsePregraph/inc/bam.h sparsePregraph/inc/bgzf.h standardPregraph/inc/zlib.h \
		standardPregraph/inc/zconf.h sparsePregraph/inc/zlib.h sparsePregraph/inc/zconf.h standardPregraph/inc/*.so \
		sparsePregraph/*.a || die
	find -type f -name "*.h" -exec sed -i -e 's/#include "sam.h"/#include "bam-0.1-legacy\/sam.h"/g' {} + || die
	find -type f -name "*.h" -exec sed -i -e 's/#include "bgzf.h"/#include "bam-0.1-legacy\/bgzf.h"/g' {} + || die
	find -type f -name "*.h" -exec sed -i -e 's/#include "sam.h"/#include "bam-0.1-legacy\/sam.h"/g' {} + || die
	find -type f -name "*.c*" -exec sed -i -e 's/#include "bam.h"/#include "bam-0.1-legacy\/bam.h"/g' {} + || die
	find -type f -name "*.c*" -exec sed -i -e 's/#include "bgzf.h"/#include "bam-0.1-legacy\/bgzf.h"/g' {} + || die
	find -type f -name "*.c*" -exec sed -i -e 's/#include "sam.h"/#include "bam-0.1-legacy\/sam.h"/g' {} + || die
	default
}
