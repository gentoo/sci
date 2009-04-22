# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran toolchain-funcs

FORTRAN="g77 gfortran ifc"

DESCRIPTION="Molecular modeling package that includes force fields, such as AMBER and CHARMM."
HOMEPAGE="http://dasher.wustl.edu/tinker/"
SRC_URI="ftp://dasher.wustl.edu/pub/tinker.tar.gz"
IUSE="X"
LICENSE="Tinker"
SLOT="0"
KEYWORDS="~x86"
# RDEPEND="dev-java/j3d-core"
S="${WORKDIR}"/tinker/source

src_compile() {
	LINK="./link.make"
	COMPILE="./compile.make"
	LIBRARY="./library.make"

	# Need to make sure all of the appropriate config files are in place
	# for the build.
	# This should be easily customizable for other Fortran compilers, e.g. pg77.
	if [[ ${FORTRANC} == "ifc" ]]; then
		cp ../linux/intel/* .
	else
		cp ../linux/gnu/* .
	fi

	cp ../make/* .

	# Prep build scripts
	sed -i -e "s:g77:${FORTRANC} ${LDFLAGS}:g" ${LINK}

	# Default to -O2 if FFLAGS is unset
	sed -i -e "s:-O3 -ffast-math:${FFLAGS:- -O2}:" ${COMPILE}
	sed -i -e "s:g77:${FORTRANC}:g" ${COMPILE}

	einfo "Compiling ..."
	${COMPILE} || die "compile failed"
	einfo "Building libraries ..."
	${LIBRARY} || die "library creation failed"
	einfo "Linking ..."
	${LINK} || die "link failed"
}

src_install() {
	exeinto /usr/bin

	dodoc \
		"${WORKDIR}"/tinker/doc/*.txt \
		"${WORKDIR}"/tinker/doc/release-4.2 \
		"${WORKDIR}"/tinker/doc/*.pdf

	dolib.a libtinker.a

	for EXE in *.x; do
		newexe ${EXE} ${EXE%.x}
	done

	docinto example
	dodoc "${WORKDIR}"/tinker/example/*
	docinto test
	dodoc "${WORKDIR}"/tinker/test/*

	doexe "${WORKDIR}"/tinker/perl/mdavg

	insinto /usr/share/tinker/params
	doins "${WORKDIR}"/tinker/params/*
}

pkg_postinst() {
	einfo "Tinker binaries installed to ${ROOT}usr/bin."
	einfo "Parameter files installed to ${ROOT}usr/share/tinker/params."
}
