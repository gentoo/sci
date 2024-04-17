# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# python only needed for create.py to get binaries
PYTHON_COMPAT=( python3_{10..12} )
inherit fortran-2 python-any-r1 toolchain-funcs

DESCRIPTION="Library of one-loop scalar functions"
HOMEPAGE="
	https://helac-phegas.web.cern.ch/OneLOop.html
	https://bitbucket.org/hameren/oneloop
"
SRC_URI="https://bitbucket.org/hameren/oneloop/get/3762b8bad6ad.zip -> ${P}.zip"
S="${WORKDIR}/hameren-oneloop-3762b8bad6ad"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+dpkind +qpkind qpkind16 dpkind16 qdcpp ddcpp mpfun90 arprec tlevel cppintf"
REQUIRED_USE="
	?? ( dpkind dpkind16 ddcpp )
	?? ( qpkind qpkind16 qdcpp )
	?? ( arprec mpfun90 )
	|| ( dpkind dpkind16 ddcpp qpkind qpkind16 qdcpp )
"

DEPEND="
	qpkind? ( sci-libs/qd )
	qpkind16? ( sci-libs/qd )
	arprec? ( sci-libs/arprec )
	mpfun90? ( sci-libs/mpfun90 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip
"

src_configure() {
	tc-export FC
	# set fortran
	sed -i "/FC = /s/gfortran/${FC}/g" Config || die
	sed -i "/FFLAGS = /s/ -O/${FFLAGS} -fPIC/g" Config || die
	# Clear config
	sed -i "s/^DPKIND.*$//g" Config || die
	sed -i "s/^QPKIND.*$//g" Config || die

	if use dpkind ; then
		echo "DPKIND = kind(1d0)" >> Config || die
	fi
	if use qpkind ; then
		echo "QPKIND = kind(1d0)" >> Config || die
	fi
	if use dpkind16 ; then
		echo "DPKIND = 16" >> Config || die
	fi
	if use qpkind16 ; then
		echo "QPKIND = 16" >> Config || die
	fi

	if use qdcpp ; then
		echo "QDTYPE = qdcpp" >> Config || die
	fi
	if use ddcpp ; then
		echo "DDTYPE = qdcpp" >> Config || die
	fi

	if use mpfun90 ; then
		echo "MPTYPE = mpfun90" >> Config || die
	fi
	if use arprec ; then
		echo "MPTYPE = arprec" >> Config || die
	fi

	if use tlevel ; then
		sed -i "s/^.*TLEVEL.*$/TLEVEL = yes/" Config || die
	else
		sed -i "s/^.*TLEVEL.*$/TLEVEL = no/" Config || die
	fi
	if use cppintf ; then
		sed -i "s/^.*CPPINTF.*$/CPPINTF = yes/" Config || die
	else
		sed -i "s/^.*CPPINTF.*$/CPPINTF = no/" Config || die
	fi
}

src_compile() {
	tc-export FC
	#emake -f make_cuttools
	${EPYTHON} ./create.py source || die "Failed to compile"
	# create.py does not use soname, so we do it ourself
	#./create.py dynamic || die
	${FC} -O -fPIC -c avh_olo.f90 -o avh_olo.o || die
	${FC} ${LDFLAGS} -Wl,-soname,libavh_olo.so -shared -o libavh_olo.so *.o || die
}

src_install() {
	#dolib.a libavh_olo.a
	dolib.so libavh_olo.so
	doheader *.mod
	dosym libavh_olo.so /usr/$(get_libdir)/liboneloop.so
}
