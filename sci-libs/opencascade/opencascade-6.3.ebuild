# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit autotools eutils flag-o-matic qt3 check-reqs multilib toolchain-funcs versionator

DESCRIPTION="Software development platform for CAD/CAE, 3D surface/solid modeling and data exchange."
HOMEPAGE="http://www.opencascade.org"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/thierry/${P}.tar.bz2"

# NOTES
# The source code here is not in the same form than the one distributed on www.opencascade.org
# The source available on www.opencascade.org requires a Java installation procedure that does not
# always work on Gentoo. The source code can however be extracted 'by hand' using
# 'java -cp ./Linux/setup.jar'
# and removing 'by hand' all the existing Linux binaries. The source code extracted using this
# method is currently available on the FreeBSD ftp server.
# It could be possible to download the Salome binary for linux (500Mb...) and to extract the source from there.


LICENSE="Open-CASCADE-Technology-Public-License"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc java opengl qt3 stlport X"
DEPEND="java? ( virtual/jdk )
	opengl? ( virtual/opengl
		  virtual/glu )
	X? ( x11-libs/libXmu
		 app-text/dgs )
	>=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
	>=dev-tcltk/itcl-3.2
	>=dev-tcltk/itk-3.2
	x86? ( >=dev-tcltk/tix-8.1 )
	amd64? ( >=dev-tcltk/tix-8.4.2 )
	qt3? ( x11-libs/qt:3 )
	stlport? ( dev-libs/STLport )"

MY_S=${WORKDIR}/OpenCASCADE6.3.0
INSTALL_DIR="/opt/${P}/ros/lin"


pkg_setup() {
	# Determine itk, itcl, tix, tk and tcl versions
	itk_version=$(grep ITK_VER /usr/include/itk.h | sed 's/^.*"\(.*\)".*/\1/')
	itcl_version=$(grep ITCL_VER /usr/include/itcl.h | sed 's/^.*"\(.*\)".*/\1/')
	tix_version=$(grep TIX_VER /usr/include/tix.h | sed 's/^.*"\(.*\)".*/\1/')
	tk_version=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
	tcl_version=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')

	ewarn
	ewarn " It is important to note that OpenCascade is a very large package. "
	ewarn " Please note that building OpenCascade takes a lot of time and "
	ewarn " hardware ressources: 3.5-4 GB free diskspace and 256 MB RAM are "
	ewarn " the minimum requirements. "
	ewarn

	# Check if we have enough RAM and free diskspace to build this beast
	CHECKREQS_MEMORY="256"
	CHECKREQS_DISK_BUILD="3584"
	check_reqs
}


src_unpack() {
	unpack ${A}

	# Substitute with our ready-made env.ksh script
	cp -f "${FILESDIR}"/env.ksh.template ${MY_S}/ros/env.ksh

	# Feed environment variables used by Opencascade compilation
	cd ${MY_S}/ros
	sed -i \
		-e "s:VAR_CASROOT:${MY_S}/ros:g" \
		-e 's:VAR_SYS_BIN:/usr/bin:g' \
		-e "s:VAR_SYS_LIB:/usr/$(get_libdir):g" env.ksh \
	|| die "Environment variables feed in env.ksh failed!"

	# Tweak itk, itcl, tix, tk and tcl versions
	sed -i \
		-e "s:VAR_ITK:itk${itk_version}:g" \
		-e "s:VAR_ITCL:itcl${itcl_version}:g" \
		-e "s:VAR_TIX:tix${tix_version}:g" \
		-e "s:VAR_TK:tk${tk_version}:g" \
		-e "s:VAR_TCL:tcl${tcl_version}:g" env.ksh \
	|| die "itk, itcl, tix, tk and tcl version tweaking failed!"

	chmod u+x configure

	# Autotools version update
	source env.ksh
	eaclocal || die "eaclocal failed"
	eautoheader || die "eautoheader failed"
	eautomake -a -c -f
	_elibtoolize --force --copy || die "elibtoolize failed"
	eautoconf || die "eautoconf failed"
}

src_compile() {
	cd ${MY_S}/ros

	# Add the configure options
	local confargs="--prefix=${INSTALL_DIR} --with-tcl=/usr/$(get_libdir) --with-tk=/usr/$(get_libdir)"

	if use X ; then
		confargs="${confargs} --with-dps-include=/usr/include --with-dps-library=/usr/$(get_libdir)"
		confargs="${confargs} --with-xmu-include=/usr/include --with-xmu-library=/usr/$(get_libdir)"
		if use !opengl; then
			ewarn "Activate OpenGL if you want to be able to visualize geometry. Set "opengl" USE flag."
		else
			confargs="${confargs} --with-gl-include=/usr/include --with-gl-library=/usr/$(get_libdir)"
		fi
	else
		if use opengl; then
			die "OpenGL imply X support! Add "X" USE flag."
		else
			ewarn "Activate X and OpenGL if you want to be able to visualize geometry. Set "X" and "opengl" USE flags."
		fi
	fi

	if use java ; then
		local java_path
		java_path=`java-config -O`
		confargs="${confargs} --with-java-include=${java_path}/include/linux"
	else
		ewarn "Java wrapping is not going to be compiled. USE flag: "java""
	fi

# NOTES: To clearly state --with-stlport-include and --with-stlport-library cause troubles. I don't know why....

	if use stlport ; then
		confargs="${confargs} --with-stlport-libname=stlport_gcc"
		#confargs="${confargs} --with-stlport-include=/usr/include --with-stlport-library=/usr/$(get_libdir)"
	fi

	# Compiler and linker flags
	if use amd64 ; then
		append-flags -m64
	fi
	append-ldflags -lpthread

	econf	${confargs} \
		$(use_with X x ) \
		$(use_enable debug ) \
		$(use_enable !debug production ) \
	|| die "Configuration failed"

	emake || die "Compilation failed"
}


src_install() {
	cd ${MY_S}/ros
	rm *~
	emake prefix="${D}/${INSTALL_DIR}" install \
	|| die "Installation failed"

	# Symlinks for keeping original OpenCascade folder structure and
	# add a link lib to lib64 in ros/Linux if we are on amd64
	dosym /opt/${P}/ros/lin /opt/${P}/ros/Linux
	if use amd64 ; then
		dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib
	fi

	# Tweak the environment variables script
	cp "${FILESDIR}"/env.ksh.template env.ksh
	sed -i "s:VAR_CASROOT:/opt/${P}/ros:g" env.ksh

	# Build the env.d environment variables
	cp "${FILESDIR}"/env.ksh.template 50${PN}
	sed -i \
		-e 's:export ::g' \
		-e "s:VAR_CASROOT:/opt/${P}/ros:g" \
		-e '1,2d' \
		-e '4,14d' \
		-e "s:ros/Linux/lib/:ros/Linux/$(get_libdir)/:g" ./50${PN} \
	|| die "Creation of the /etc/env.d/50opencascade failed!"
	sed -i "2i\PATH=/opt/${P}/ros/Linux/bin/\nLDPATH=/opt/${P}/ros/Linux/$(get_libdir)" ./50${PN} \
	|| die "Creation of the /etc/env.d/50opencascade failed!"

	# Update both env.d and script with the libraries variables
	sed -i \
		-e 's:VAR_SYS_BIN:/usr/bin:g' \
		-e "s:VAR_SYS_LIB:/usr/$(get_libdir):g" \
		-e "s:VAR_ITK:itk${itk_version}:g" \
		-e "s:VAR_ITCL:itcl${itcl_version}:g" \
		-e "s:VAR_TIX:tix${tix_version}:g" \
		-e "s:VAR_TK:tk${tk_version}:g" \
		-e "s:VAR_TCL:tcl${tcl_version}:g" env.ksh 50${PN} \
	|| die "Tweaking of the Tcl/Tk libraries location in env.ksh and 50opencascade failed!"

	# Install the env.d variables file
	doenvd 50${PN}
	rm 50${PN} env.csh

	# Clean before copying everything
	cd ${MY_S}/ros
	emake clean || die "emake clean failed"

	# Install folders
	cd ${MY_S}
	insinto /opt/${P}
	doins -r data ros
	insinto /opt/${P}/samples
	doins -r samples/tutorial
	if use java ; then
		insinto /opt/${P}/samples/standard
		doins -r samples/standard/java
	fi
	if use qt3 ; then
		insinto /opt/${P}/samples/standard
		doins -r samples/standard/qt
	fi

	# Install the documentation
	if use doc ; then
		cd ${MY_S}/doc
		dodoc -r Overview  ReferenceDocumentation ../LICENSE || die "dodoc failed"
	fi
}

pkg_postinst() {
	einfo "Open CASCADE ebuild needs further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=118656"
}
