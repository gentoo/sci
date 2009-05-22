# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fortran multilib flag-o-matic distutils python

DESCRIPTION="An automated pipeline for performing Poisson-Boltzmann electrostatics calculations"
LICENSE="BSD"
HOMEPAGE="http://pdb2pqr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
IUSE="doc examples opal"
KEYWORDS=""

RDEPEND="dev-lang/python
	dev-python/numpy
	opal? ( dev-python/zsi )"
DEPEND="${RDEPEND}"

FORTRAN="g77 gfortran"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-automagic.patch
	epatch "${FILESDIR}"/${P}-install.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch

	sed '50,200s:CWD:DESTDIR:g' -i Makefile.am

	eautoreconf
}

src_compile() {
	# we need to compile the *.so as pic
	append-flags -fPIC
	FFLAGS="${FFLAGS} -fPIC"
	# Avoid automagic to numeric
	NUMPY="$(python_get_sitedir)" \
		F77="${FORTRANC}" \
		econf \
		$(use_with opal) || \
		die "econf failed"
#die
#		$(use_with opal)="http://ws.nbcr.net/opal/services/pdb2pqr_1.4.0" || \
	emake || die "emake failed"
}

src_test() {
	emake -j1 test && \
		F77="${FORTRANC}" emake -j1 adv-test || \
		die "test failed"
}

src_install() {
#	emake -j1 PREFIX="${D}"/$(python_get_sitedir)/${PN} install || die
	dodir $(python_get_sitedir)/${PN}
#	emake -j1 DESTDIR="${D}"/$(python_get_sitedir)/${PN}  install || die
	emake -j1 DESTDIR="${D}$(python_get_sitedir)/${PN}" PREFIX=""  install || die

	if use doc; then
		cd doc
		sh genpydoc.sh || die
		dohtml -r *.html images pydoc || die
		cd -
	fi

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples || die
	fi


	# generate pdb2pqr wrapper
	cat >> "${T}"/${PN} <<-EOF
		#!/bin/sh
		${python} ${INPATH}/${PN}.py \$*
	EOF

	exeinto /usr/bin
	doexe "${T}"/${PN} || die "Failed to install pdb2pqr wrapper."

	dodoc ChangeLog NEWS README AUTHORS || \
		die "Failed to install docs"

	INPATH="$(python_get_sitedir)/${PN}"

	insinto "${INPATH}"
	doins __init__.py || \
		die "Setting up the pdb2pqr site-package failed."

	exeinto "${INPATH}"
	doexe ${PN}.py || die "Installing pdb2pqr failed."

	insinto "${INPATH}"/dat
	doins dat/* || die "Installing data failed."

	exeinto "${INPATH}"/extensions
	doexe extensions/* || \
		die "Failed to install extensions."

	insinto "${INPATH}"/src
	doins src/*.py || die "Installing of python scripts failed."

	exeinto "${INPATH}"/propka
	doexe propka/_propkalib.so || \
		die "Failed to install propka."

	insinto "${INPATH}"/propka
	doins propka/propkalib.py propka/__init__.py || \
		die "Failed to install propka."

	insinto "${INPATH}"/pdb2pka
	doins pdb2pka/*.{py,so,DAT,h}
		die "Failed to install pdb2pka."

	insinto "${INPATH}"/pdb2pka/
	doins pdb2pka/*.{py,so,DAT,h}
		die "Failed to install pdb2pka."


}
