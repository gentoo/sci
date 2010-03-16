# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic

DESCRIPTION="Modeling and Exchange of Data library"
HOMEPAGE="http://www.code-aster.org/outils/med/"
SRC_URI="http://files.opencascade.com/Salome/Salome5.1.3/med-fichier_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=">=sci-libs/hdf5-1.6.4"
RDEPEND=${DEPEND}

S=${WORKDIR}/med-${PV}_SRC

src_prepare() {
	if has_version ">=sci-libs/hdf5-1.8.3"; then
		append-flags -DH5_USE_16_API
	fi
}

src_configure() {
	local myconf

	myconf="--docdir=/usr/share/doc/${PF}"
	## has been desabled, in order to compile salome-med
	#use amd64 && myconf="${myconf} --with-med_int=long"
	econf ${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install \
		|| die "emake install failed"

	rm -R "${D}"/usr/share/doc/*
	rm -R "${D}"/usr/bin/testc
	rm -R "${D}"/usr/bin/testf

	if use doc; then
		dodoc AUTHORS NEWS README ChangeLog \
			|| die "dodoc failed"
		dohtml -r doc/index.html doc/med.css doc/html doc/jpg \
			doc/png doc/gif doc/tests || die "dohtml failed"
	fi

	if use examples; then
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
