# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
FORTRAN="gfortran ifc"

inherit fortran

DESCRIPTION="Molecular modeling package that includes force fields, such as AMBER and CHARMM."
HOMEPAGE="http://dasher.wustl.edu/tinker/"
SRC_URI="ftp://dasher.wustl.edu/pub/tinker.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Tinker"
KEYWORDS="~amd64 ~x86"
IUSE=""

# RDEPEND="dev-java/j3d-core"
RESTRICT="mirror"

S="${WORKDIR}"/tinker/source

src_compile() {
	LINK="./link.make"
	COMPILE="./compile.make"
	LIBRARY="./library.make"

	# Need to make sure all of the appropriate config files are in place
	# for the build.
	# This should be easily customizable for other Fortran compilers, e.g. pg77.
	if [[ ${FORTRANC} == "ifort" ]]; then
		cp ../linux/intel/* .
	else
		cp ../linux/gfortran/* .
	fi

	cp ../make/* .

	# Prep build scripts
	sed -i -e "s:gfortran:${FORTRANC} ${LDFLAGS}:g" ${LINK}
	sed -r -i -e "s:^${FORTRANC}.+$:echo &\n&:" ${LINK}

	# Default to -O2 if FFLAGS is unset
	sed -i -e "s:-O:${FFLAGS:- -O2}:" ${COMPILE}
	sed -r -i -e "s:^${FORTRANC}.+$:echo &\n&:" ${COMPILE}

	einfo "Compiling ..."
	${COMPILE} || die "compile failed"
	einfo "Building libraries ..."
	${LIBRARY} || die "library creation failed"
	einfo "Linking ..."
	${LINK} || die "link failed"
}

src_install() {
	dodoc \
		"${WORKDIR}"/tinker/doc/*.txt \
		"${WORKDIR}"/tinker/doc/announce/release-* \
		"${WORKDIR}"/tinker/doc/*.pdf \
		"${WORKDIR}"/tinker/doc/README || die

	dolib.a libtinker.a || die

	for EXE in *.x; do
		newbin ${EXE} ${EXE%.x} || die
	done

	docinto example
	dodoc "${WORKDIR}"/tinker/example/* || die

	docinto test
	dodoc "${WORKDIR}"/tinker/test/* || die

	dobin "${WORKDIR}"/tinker/perl/mdavg || die

	insinto /usr/share/tinker/params
	doins "${WORKDIR}"/tinker/params/* || die
}
