# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Error corrector for RNA-Seq reads"
HOMEPAGE="http://sb.cs.cmu.edu/seecer/"
SRC_URI="http://sb.cs.cmu.edu/seecer/downloads/SEECER-0.1.3.tar.gz
	http://sb.cs.cmu.edu/seecer/downloads/manual.pdf"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-libs/gsl
	sci-biology/seqan
	sci-biology/jellyfish"
RDEPEND="${DEPEND}"

S="${S}"/SEECER

# doh, it install /usr/bin/seecer (note the lowercase letters)

# checking for x86_64-pc-linux-gnu-gcc option to support OpenMP... -fopenmp
# 
# Uses:
#         libgomp.so.1 => /usr/lib/gcc/x86_64-pc-linux-gnu/4.8.3/libgomp.so.1 (0x00007f7853faf000)


# dobin bin/run_seecer.sh
# dodoc "${DISTDIR}"/manual.pdf
