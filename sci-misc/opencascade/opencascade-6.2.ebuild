# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils flag-o-matic qt3 check-reqs

DESCRIPTION="Software development platform for CAD/CAE, 3D surface/solid modeling and data exchange."
HOMEPAGE="http://www.opencascade.org"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/thierry/${P}.tar.bz2
	 ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/thierry/${PN}-tutorial-${PV}.tar.bz2
		 java? (ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/thierry/${PN}-samples-java-${PV}.tar.bz2)
		 qt3? (ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/thierry/${PN}-samples-qt-${PV}.tar.bz2)"

# NOTES
# The source code here is not in the same form than the one distributed on www.opencascade.org
# The source available on www.opencascade.org requires a Java installation procedure that does not
# always work on Gentoo. The source code can however be extracted 'by hand' using
# 'java -cp ./Linux/setup.jar'
# and removing 'by hand' all the existing Linux binaries. The source code extracted using this
# method is currently available on the FreeBSD ftp server.
# It could be possible to download the Salome binary for linux (500Mb...) and to extract the source from there.


LICENSE="Open CASCADE Technology Public License"
SLOT=0
KEYWORDS="~x86 ~amd64"
IUSE="debug doc draw-harness java opengl qt3 stlport X wok"
DEPEND="java? ( virtual/jdk )
		opengl? ( virtual/opengl )
		X? ( x11-base/xorg-x11 )
		>=dev-lang/tcl-8.4
		>=dev-lang/tk-8.4
		>=dev-tcltk/itcl-3.2
		>=dev-tcltk/itk-3.2
		x86? ( >=dev-tcltk/tix-8.1 )
		amd64? ( >=dev-tcltk/tix-8.4.2 )
	qt3? ( $(qt_min_version 3) )
		stlport? ( dev-libs/STLport )
		sys-devel/autoconf
		sys-devel/automake
		sys-devel/libtool"

pkg_setup() {
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
	cp -f "${FILESDIR}"/env.ksh.template "${S}"/ros/env.ksh

	# Feed environment variables used by Opencascade compilation
		cd "${S}"/ros
	sed -i "s:VAR_CASROOT:${S}/ros:g" env.ksh
	sed -i "s:VAR_SYS_BIN:/usr/bin:g" env.ksh
	sed -i "s:VAR_SYS_LIB:/usr/lib:g" env.ksh

	# Tweak itk version
		local itk_version
		itk_version=$(grep ITK_VER /usr/include/itk.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_ITK:itk${itk_version}:g" env.ksh

	# Tweak itcl version
		local itcl_version
		itcl_version=$(grep ITCL_VER /usr/include/itcl.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_ITCL:itcl${itcl_version}:g" env.ksh

	# Tweak tix version
		local tix_version
		tix_version=$(grep TIX_VER /usr/include/tix.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_TIX:tix${tix_version}:g" env.ksh

	# Tweak tk version
		local tk_version
		tk_version=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_TK:tk${tk_version}:g" env.ksh

	# Tweak tcl version
		local tcl_version
		tcl_version=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_TCL:tcl${tcl_version}:g" env.ksh

	# Patches
	if [ gcc-major-version > 4 ] ; then
		elog "You have gcc4 -> GCC 4.x patch is applied"
		epatch "${FILESDIR}"/opencascade-6.2-gcc4.patch
	fi
	elog "Stdlib malloc patch is applied"
	epatch "${FILESDIR}"/opencascade-6.2-malloc.patch
		chmod u+x configure
}

src_compile() {
		cd "${S}"/ros

	# Autotools version update
		source env.ksh
		eaclocal || die "eaclocal failed"
		eautoheader || die "eautoheader failed"
		eautomake -a -c -f
		_elibtoolize --force --copy || die "elibtoolize failed"
		eautoconf || die "eautoconf failed"

		# Add the configure options
		if use opengl && use !X ; then
				ewarn "OpenGL imply X support! Add "opengl" USE flag."
				die
		fi

		local confargs="--prefix=/opt/${P}/ros/lin --with-tcl=/usr/lib/ --with-tk=/usr/lib/"

		if use X ; then
				confargs="${confargs} --with-xmu-include=/usr/include --with-xmu-library=/usr/lib"
				if use opengl; then
						confargs="${confargs} --with-gl-include=/usr/include --with-gl-library=/usr/lib"
				else
			ewarn "Activate OpenGL if you want to be able to visualize geometry. Set opengl USE flag."
				fi
		else
		ewarn "Activate X and OpenGL if you want to be able to visualize geometry. Set "X" and "opengl" USE flags."
		fi

		if use !debug ; then
				confargs="${confargs} --disable-debug --enable-production"
		else
				confargs="${confargs} --enable-debug"
		fi

		if use stlport ; then
				confargs="${confargs} --with-stlport-libname=stlport_gcc"
		fi

	if use java ; then
		local java_path
		java_path=`java-config -O`
		confargs="${confargs} --with-java-include=${java_path}/include/linux"
	else
		confargs="${confargs} --disable-jcas"
		elog "Java wrapping is not going to be compiled. USE flag: java"
	fi

	if use !wok ; then
		confargs="${confargs} --disable-wok"
		elog "WOK is not going to be compiled. USE flag: wok"
	fi

	if use !draw-harness ; then
		confargs="${confargs} --disable-draw"
		elog "DRAW test harness is not going to be compiled. USE flag: draw-harness"
	fi

	# Compiler and linker flags
	if use amd64 ; then
		append-flags -m64
	fi
		append-ldflags -lpthread

		econf ${confargs} || die "econf failed"
		emake || die "emake failed"
}


src_install() {
		cd "${S}"/ros
		rm *~
		emake install DESTDIR="${D}" || die "emake install failed"

	# Symlinks for keeping original OpenCascade folder structure
		dosym /opt/${P}/ros/lin /opt/${P}/ros/Linux
	if use amd64 ; then
		dosym /opt/${P}/ros/lin/lib64 /opt/${P}/ros/lin/lib
	fi

	# Tweak the environment variables script
	cp "${FILESDIR}"/env.ksh.template env.ksh
		sed -i "s:VAR_CASROOT:/opt/${P}/ros:g" env.ksh

	# Build the env.d environment variables
	cp "${FILESDIR}"/env.ksh.template 50${PN}
		sed -i "s:export ::g" ./50${PN}
		sed -i "s:VAR_CASROOT:/opt/${P}/ros:g" 50${PN}
		sed -i "1,2d" ./50${PN}
		sed -i "2,12d" ./50${PN}
	sed -i "2i\PATH=/opt/${P}/ros/Linux/bin/\nLDPATH=/opt/${P}/ros/Linux/lib" ./50${PN}

	# Update both env.d and script with the libraries variables
		sed -i "s:VAR_SYS_BIN:/usr/bin:g" env.ksh 50${PN}
		sed -i "s:VAR_SYS_LIB:/usr/lib:g" env.ksh 50${PN}
	local itk_version
		itk_version=$(grep ITK_VER /usr/include/itk.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_ITK:itk${itk_version}:g" env.ksh 50${PN}
		local itcl_version
		itcl_version=$(grep ITCL_VER /usr/include/itcl.h | sed 's/^.*"\(.*\)".*/\1/')
	sed -i "s:VAR_ITCL:itcl${itcl_version}:g" env.ksh 50${PN}
		local tix_version
		tix_version=$(grep TIX_VER /usr/include/tix.h | sed 's/^.*"\(.*\)".*/\1/')
	sed -i "s:VAR_TIX:tix${tix_version}:g" env.ksh 50${PN}
	local tk_version
		tk_version=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
		sed -i "s:VAR_TK:tk${tk_version}:g" env.ksh 50${PN}
		local tcl_version
		tcl_version=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
	sed -i "s:VAR_TCL:tcl${tcl_version}:g" env.ksh 50${PN}

	# Install the env.d variables file
		dodir /etc/env.d
		insinto /etc/env.d
		doins 50${PN}
		rm 50${PN} env.csh

	# Install binaries
	cd "${D}"/opt/"${P}"/ros/lin/bin
	if use draw-harness ; then
		newbin DRAWEXE draw-harness
	fi
	if use wok ; then
		dobin woksh
		dobin wokprocess
	fi

	# Clean before copying everything
	cd "${S}"/ros
	emake clean || die "emake clean failed"

		# Install folders
		cd "${S}"
		insinto /opt/${P}
		doins -r data ros tools wok samples

		# Install the documentation
	if use doc ; then
		cd "${S}"/doc
				insinto /usr/share/doc/${PF}
				doins -r * || die "doins doc failed"
	fi
}

pkg_postinst() {
		einfo "Open CASCADE ebuild needs further development. Please inform any problems or improvements in http://bugs.gentoo.org/show_bug.cgi?id=118656"
}
