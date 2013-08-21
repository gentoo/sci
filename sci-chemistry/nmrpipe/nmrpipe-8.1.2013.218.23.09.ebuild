# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Versioning is output of nmrPipe -help

EAPI=5

inherit eutils virtualx

DESCRIPTION="Spectral visualisation, analysis and Fourier processing"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/NMRPipe/"
#SRC_URI="
#	NMRPipeX.tZ
#	talos.tZ
#	dyn.tZ
#	binval.com
#	install.com"
SRC_URI="
	http://spin.niddk.nih.gov/NMRPipe/install/download/install.com
	http://spin.niddk.nih.gov/NMRPipe/install/download/binval.com
	http://spin.niddk.nih.gov/NMRPipe/install/download/NMRPipeX.tZ
	http://spin.niddk.nih.gov/NMRPipe/install/download/talos.tZ
	http://spin.niddk.nih.gov/NMRPipe/install/download/dyn.tZ
	"

SLOT="0"
LICENSE="nmrpipe"
# Right now, precompiled executables are only available for Linux on the
# x86 architecture. The maintainer chose to keep the sources closed, but
# says he will gladly provide precompiled executables for other platforms
# if there are such requests.
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

#RESTRICT="fetch strip"
RESTRICT="strip"

DEPEND="app-shells/tcsh"
RDEPEND="${DEPEND}
	app-editors/nedit
	dev-lang/tk
	dev-tcltk/blt
	media-fonts/font-sun-misc
	!sci-chemistry/sparta+
	!sci-chemistry/talos+
	sys-libs/ncurses
	x11-apps/xset
	x11-libs/libX11
	|| ( x11-libs/xview x11-libs/xview-bin )
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
	)
	prefix? ( dev-util/patchelf )"

S="${WORKDIR}"

NMRBASE="/opt/${PN}"
ENMRBASE="${EPREFIX}/${NMRBASE}"

QA_PREBUILT="
	opt/nmrpipe/nmrbin.linux9/lib/.*
	opt/nmrpipe/nmrbin.linux9/.*
	opt/nmrpipe/talos/bin/.*
	opt/nmrpipe/talosplus/bin/.*
	opt/nmrpipe/promega/.*
	opt/nmrpipe/spartaplus/.*
	"

pkg_nofetch() {
	einfo "Please visit:"
	einfo "\t${HOMEPAGE}"
	einfo
	einfo "Contact the author, then download the following files:"
	for i in ${A}; do
		einfo "\t${i}"
	done
	einfo
	einfo "Place the downloaded files in your distfiles directory:"
	einfo "\t${DISTDIR}"
}

src_unpack() {
	# The installation script will unpack the package. We just provide symlinks
	# to the archive files, ...
	for i in NMRPipeX.tZ talos.tZ dyn.tZ; do
		ln -sf "${DISTDIR}"/${i} || die
	done
	# ... copy the installation scripts ...
	cp -L "${DISTDIR}"/{binval.com,install.com} .
	# ... and make the installation scripts executable.
	chmod +x binval.com install.com
	# Unset DISPLAY to avoid the interactive graphical test.
	# This just unpacks the stuff
#	env DISPLAY="" csh ./install.com +type linux9 +dest "${S}"/NMR || die
	VIRTUALX_COMMAND="csh ./install.com +type linux9 +dest ${S}/NMR +nopost" virtualmake
}

src_prepare() {
	local bin
	epatch "${FILESDIR}"/${P}-lib.patch

	mv nmrbin.linux9/nmr{W,w}ish || die

	ebegin "Cleaning installation"
	for i in ${A} ; do
		rm -f ${i} || die "Failed to remove archive symlinks."
	done

	# Remove some of the bundled applications and libraries; they are provided by Gentoo instead.
#	rm -r nmrbin.linux9/{lib/{libBLT24.so,libolgx.so*,libxview.so*,*.timestamp},*timestamp,xv,gnuplot*,rasmol*,nc,nedit} \
	rm -rf nmrbin.linux9/{lib/*.timestamp,*timestamp,xv,gnuplot*,rasmol*,nc,nedit} \
		nmrbin.{linux,mac,sgi6x,sol,winxp} nmruser format \
		|| die "Failed to remove unnecessary libraries."
	# As long as xview is not fixed for amd64 we do this
	rm nmrbin.linux9/lib/{libxview.so*,libolgx.so*} || die
	# Remove the initialisation script generated during the installation.
	# It contains incorrect hardcoded paths; only the "nmrInit.com" script
	# should be used.
	rm -f com/nmrInit.linux9.com || die "Failed to remove broken init script."
	# Remove installation log files.
	rm -f README_NMRPIPE_USERS *.log || die "Failed to remove installation log."
	# Remove unused binaries
	rm -f {talos*,spartaplus,promega}/bin/*{linux,mac,sgi6x,winxp} pdb/misc/addSeg || die

	# Some scripts are on the wrong place
	cp -f nmrtxt/*.com com/
	rm -f {acme,com}/{nmrproc,fid}.com || die

	eend

	ebegin "Fixing paths in scripts"

	# Set the correct path to NMRPipe in the auxiliary scripts.
	for i in $(find com/ dynamo/surface/misc/ nmrtxt/ talos/misc talosplus/com -type f); do
		sed -e "s%/u/delaglio%${ENMRBASE}%" -i ${i} || die \
			"Failed patching scripts."
	done
	sed -i "s:${WORKDIR}:${ENMRBASE}:g" com/font.com || die

	sed \
		-e "s:!/bin:!${EPREFIX}/bin:g" \
		-e "s:!/usr/bin:!${EPREFIX}/usr/bin:g" \
		-e "s:!/usr/local/bin:!${EPREFIX}/usr/bin:g" \
		-e "s: /bin: ${EPREFIX}/bin:g" \
		-e "s: /usr/bin: ${EPREFIX}/usr/bin:g" \
		-e "s: /usr/local/bin: ${EPREFIX}/usr/bin:g" \
		-i $(find "${S}" \( -name *.tcl -o -name *.com -o -name *.ksh \) ) \
			{com/,nmrtxt/*.com,nmrtxt/nt/*.com,dynamo/tcl/,talos*/com/,dynamo/tcl/}* \
			nmrbin.linux9/{nmrDraw,xNotify} || die

	eend

	if use prefix; then
		sed \
			-e "s: sh : \"${EPREFIX}/bin/sh\" :g" \
			-e "s: csh : \"${EPREFIX}/bin/csh\" :g" \
			-e "s: bash : \"${EPREFIX}/bin/bash\" :g" \
			-e "s:appTerm -e:appTerm -e \"${EPREFIX}/bin/csh\":g" \
			-i com/* || die

		ebegin "Setting RPATH in binaries"
		for bin in $(find nmrbin.linux9/ -type f -maxdepth 1); do
			patchelf --set-rpath "${EPREFIX}/usr/lib/" ${bin}
		done
		eend $?
	fi
}

src_install() {
	cat >> "${T}"/nmrWish <<- EOF
	#!${EPREFIX}/bin/csh -f
	setenv NMRBIN \${NMRBASE}/bin/
	setenv NMRLIB \${NMRBIN}/lib
	setenv AUXLIB \${NMRBIN}/openwin/lib
	setenv TCLPATH \${NMRBASE}/com
	setenv TCL_LIBRARY \${NMRBASE}/nmrtcl/tcl8.4
	setenv TK_LIBRARY \${NMRBASE}/nmrtcl/tk8.4
	setenv BLT_LIBRARY \${NMRBASE}/nmrtcl/blt2.4
	setenv NMRPIPE_TCL_LIB \${NMRBASE}/nmrtcl/tcl8.4
	setenv NMRPIPE_TK_LIB \${NMRBASE}/nmrtcl/tk8.4
	setenv NMRPIPE_BLT_LIB \${NMRBASE}/nmrtcl/blt2.4

	if (!(\$?LD_LIBRARY_PATH)) then
		setenv LD_LIBRARY_PATH \${NMRLIB}:\${AUXLIB}
	else
		setenv LD_LIBRARY_PATH \${NMRLIB}:\${LD_LIBRARY_PATH}:\${AUXLIB}
	endif

	nmrwish \$*
	EOF

	sed \
		-e "s:/opt/nmrpipe:${EPREFIX}/opt/nmrpipe:g" \
		"${FILESDIR}"/env-${PN}-new \
		> env-${PN}-new || die
	newenvd env-${PN}-new 40${PN}

	insinto ${NMRBASE}
	doins -r *

	dosym nmrbin.linux9 ${NMRBASE}/bin

	ebegin "Fixing permissions"
	chmod 775 "${ED}"/${NMRBASE}/{talos*/bin/,sparta*/bin/,nmrbin.linux9/,com/,dynamo/tcl/,nmrtxt/*.com,talos*/com/,promega/bin/}* || die
	eend

	exeinto ${NMRBASE}/nmrbin.linux9
	doexe "${T}"/nmrWish
}
