# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="FASTA is a DNA and Protein sequence alignment software package"
HOMEPAGE="http://fasta.bioch.virginia.edu/fasta_www2/fasta_down.shtml"
SRC_URI="http://faculty.virginia.edu/wrpearson/${PN}/${PN}3/${P}.tar.gz"

LICENSE="fasta"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug icc sse2 test"

DEPEND="
	icc? ( dev-lang/icc )
	test? ( app-shells/tcsh )"
RDEPEND=""

src_prepare() {
	CC_ALT=
	CFLAGS_ALT=
	ALT=

	if use debug ; then
		CFLAGS_ALT="-g -DDEBUG"
	fi

	if use icc ; then
		CC_ALT=icc
		ALT="${ALT}_icc"
	else
		CC_ALT=gcc

		case $(uname -m) in

			i*86		)
				ALT="32";;

			x86_64	)
				ALT="64";;

		esac
	fi

	if use sse2 ; then
		ALT="${ALT}_sse2"
		CFLAGS_ALT="${CFLAGS_ALT} -msse2"
		if ! use icc ; then
			CFLAGS_ALT="${CFLAGS_ALT} -ffast-math"
		fi
	fi

	export CC_ALT="${CC_ALT}"
	export CFLAGS_ALT="${CFLAGS_ALT}"
	export ALT="${ALT}"

	epatch "${FILESDIR}"/${PV}-ldflags.patch
}

src_compile() {
	einfo "Using $CC_ALT compiler"
	cd src
	make -f ../make/Makefile.linux${ALT} CC="${CC_ALT} ${CFLAGS} ${CFLAGS_ALT}" HFLAGS="${LDFLAGS} -o" all || die
}

src_test() {
	cd test
	PATH="${S}/bin:${PATH}" csh test.sh
}

src_install() {
	dobin bin/* || die
	doman doc/{prss3.1,fasta35.1,pvcomp.1,fasts3.1,fastf3.1,ps_lav.1,map_db.1} || die
	dodoc  FASTA_LIST README doc/{README.versions,readme*,fasta*,changes*} || die
}
