# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils flag-o-matic

DESCRIPTION="Modeling and Exchange of Data library"
HOMEPAGE="http://www.code-aster.org/outils/med/"
SRC_URI="http://files.opencascade.com/Salome/Salome5.1.2/med-fichier_2.3.5.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

DEPEND="sci-libs/hdf5"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack med-fichier_${PV}.tar.gz
	mv med-fichier_${PV} ${PF}
}

src_prepare() {
	if has_version ">=sci-libs/hdf5-1.8.3"; then
		append-flags -DH5_USE_16_API
# this patch is only neede with hdf5-1.8.3, probably because hdf5-1.6.7
# included the missing headers 
		epatch "${FILESDIR}/${P}-gcc-4.3.patch"
	fi
}

src_configure() {
	local myconf

	myconf="--docdir=/usr/share/doc/${PF}"
	use amd64 && myconf="${myconf} --with-med_int=long"
	econf ${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install \
		|| die "emake install failed"

	rm -R "${D}"/usr/share/doc/*
	rm -R "${D}"/usr/bin/testc
	rm -R "${D}"/usr/bin/testf


	if use doc
	then
		dodoc AUTHORS NEWS LGPL README ChangeLog \
			|| die "dodoc failed"
		dohtml -r doc/index.html doc/med.css doc/html doc/jpg \
			doc/png doc/gif doc/tests || die "dohtml failed"
	fi

	if use examples
	then
		dodir /usr/share/doc/${PF}/examples/c/.libs
		exeinto /usr/share/doc/${PF}/examples/c
		for i in `ls tests/c/*.o` ;
		do
			doexe tests/c/`basename ${i} .o` || die "doexe failed"
		done
		exeinto /usr/share/doc/${PF}/examples/c/.libs
		doexe  tests/c/.libs/* || die "doexe failed"

		dodir /usr/share/doc/${PF}/examples/f/.libs
		exeinto /usr/share/doc/${PF}/examples/f
		for i in `ls tests/f/*.o` ;
		do
			doexe tests/f/`basename ${i} .o` || die "doexe failed"
		done
		exeinto /usr/share/doc/${PF}/examples/f/.libs
		doexe tests/f/.libs/* || die "doexe failed"
	fi
}
