# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/tinker/tinker-4.2-r1.ebuild,v 1.4 2008/11/06 23:53:23 dberkholz Exp $

inherit fortran toolchain-funcs

FORTRAN="g77 gfortran ifc"

DESCRIPTION="TINKER is a molecular modeling package that includes force fields for handing large molecules and large systems, such as AMBER and CHARMM.  A Java based visualization front end is included."
HOMEPAGE="http://dasher.wustl.edu/tinker/"
SRC_URI="ftp://dasher.wustl.edu/pub/tinker.tar.gz"
IUSE="X"
LICENSE="Tinker"
SLOT="0"
KEYWORDS="~x86"

DEPEND="X? ( dev-java/sun-java3d-bin )"
S=${WORKDIR}/tinker/source

src_compile() {
	if use X; then
		COMPGUI="./compgui.make"
		LINK="./linkgui.make"
		cp ../jar/linux/sockets.c .
	else
		LINK="./link.make"
	fi

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
	if use X; then
		sed -i \
			-e "s:-O3:${CFLAGS}:" \
			-e "s:gcc:$(tc-getCC):" \
			${COMPGUI}
		local JAVA_HOME=$(java-config --jdk-home)
		local JAVA_LIB_PATH="${JAVA_HOME}/jre/lib/i386/client"
		ln -s ${JAVA_LIB_PATH}/libjvm.so
		sed -i -e "s:/local/java/j2sdk1.4.2_05:${JAVA_HOME}:g" ${COMPGUI}
	fi

		sed -i -e "s:g77:${FORTRANC}:g" ${LINK}

	# Default to -O2 if FFLAGS is unset
	sed -i -e "s:-O3 -ffast-math:${FFLAGS:- -O2}:" ${COMPILE}
	sed -i -e "s:g77:${FORTRANC}:g" ${COMPILE}

	# Prep executable script - the one packaged with the distro is b0rked
	if use X; then
		echo 'java -Djava.library.path=$(java-config -i sun-java3d-bin) -cp $(java-config -p sun-java3d-bin):/usr/lib/tinker/ffe.jar ffe.Main' > tinker
	fi

	einfo "Compiling ..."
	if use X; then
		${COMPGUI} || die "GUI compile failed"
	fi
	${COMPILE} || die "compile failed"
	einfo "Building libraries ..."
	${LIBRARY} || die "library creation failed"
	einfo "Linking ..."
	${LINK} || die "link failed"
}

src_install() {
	exeinto /usr/bin

	dodoc \
		${WORKDIR}/tinker/doc/*.txt \
		${WORKDIR}/tinker/doc/release-4.2 \
		${WORKDIR}/tinker/doc/*.pdf

	if use X; then
		dolib.so ${WORKDIR}/tinker/jar/linux/libffe.so
	fi

	dolib.a libtinker.a

	insinto /usr/lib/tinker
	if use X; then
		doins ${WORKDIR}/tinker/jar/ffe.jar
	fi

	for EXE in *.x; do
		newexe ${EXE} ${EXE%.x}
	done

	if use X; then
		doexe tinker
	fi

	docinto example
	dodoc ${WORKDIR}/tinker/example/*
	docinto test
	dodoc ${WORKDIR}/tinker/test/*

	doexe ${WORKDIR}/tinker/perl/mdavg

	insinto /usr/share/tinker/params
	doins ${WORKDIR}/tinker/params/*
}

pkg_postinst() {
	einfo "Tinker binaries installed to ${ROOT}usr/bin."
	einfo "Parameter files installed to ${ROOT}usr/share/tinker/params."
	einfo "Call the Java X front-end, Force-Field Explorer, with 'tinker.'"
	einfo "It doesn't seem to detect installed Java3D yet, fixes welcome."
	einfo "You must edit ${ROOT}usr/bin/tinker if you aren't using Blackdown."
}
