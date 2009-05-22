# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fortran multilib flag-o-matic python

DESCRIPTION="An automated pipeline for performing Poisson-Boltzmann electrostatics calculations"
LICENSE="BSD"
HOMEPAGE="http://pdb2pqr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
IUSE="doc examples"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/python
	dev-python/numpy"
DEPEND="${RDEPEND}"

FORTRAN="g77 gfortran"

src_prepare() {
	python_version
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-automagic.patch
	epatch "${FILESDIR}"/${P}-install.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch

	sed '50,200s:CWD:DESTDIR:g' -i Makefile.am

	eautoreconf
}

src_configure() {
	# we need to compile the *.so as pic
	append-flags -fPIC

	# Avoid automagic to numeric
	NUMPY="$(python_get_sitedir)" \
		F77="${FORTRANC}" \
		econf || \
		die "econf failed"
}

src_test() {
	emake -j1 test || die
}

src_install() {
	INPATH="$(python_get_sitedir)/${PN}"
	dodir "${INPATH}"
	emake -j1 DESTDIR="${D}${INPATH}" PREFIX="" install || die

	if use doc; then
		( cd doc && sh genpydoc.sh ) || die
		dohtml -r doc/{*.html,images,pydoc} || die
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
}
