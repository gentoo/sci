# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="Modeling and Exchange of Data library"
HOMEPAGE="http://www.code-aster.org/outils/med/"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/med-fichier_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=">=sci-libs/hdf5-1.6.4"
RDEPEND=${DEPEND}

S=${WORKDIR}/med-${PV}_SRC

src_prepare() {
	has_version ">=sci-libs/hdf5-1.8.3" &&	append-cppflags -DH5_USE_16_API
}

src_configure() {
	local myconf

	myconf="--docdir=/usr/share/doc/${PF}"
	## has been desabled, in order to compile salome-med
	#use amd64 && myconf="${myconf} --with-med_int=long"
	econf ${myconf}
}

src_install() {
	default

	rm -R "${ED}"/usr/share/doc/* "${ED}"/usr/bin/testc "${ED}"/usr/bin/testf

	use doc && \
		dohtml -r doc/index.html doc/med.css doc/html doc/jpg \
			doc/png doc/gif doc/tests

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
