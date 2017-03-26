# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Versioning is output of nmrPipe -help

EAPI=6

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
	http://spin.niddk.nih.gov/NMRPipe/install/download/install.com -> install-${PV}.com
	http://spin.niddk.nih.gov/NMRPipe/install/download/binval.com -> binval-${PV}.com
	http://spin.niddk.nih.gov/NMRPipe/install/download/NMRPipeX.tZ -> NMRPipeX-${PV}.tZ
	http://spin.niddk.nih.gov/NMRPipe/install/download/plugin.smile.tZ -> plugin.smile-${PV}.tZ
	http://spin.niddk.nih.gov/NMRPipe/install/download/talos.tZ -> talos-${PV}.tZ
	http://spin.niddk.nih.gov/NMRPipe/install/download/dyn.tZ -> dyn-${PV}.tZ
	"

SLOT="0"
LICENSE="nmrpipe"
# Right now, precompiled executables are only available for Linux on the
# x86 architecture. The maintainer chose to keep the sources closed, but
# says he will gladly provide precompiled executables for other platforms
# if there are such requests.
KEYWORDS=""
IUSE=""

RESTRICT="strip"

DEPEND="app-shells/tcsh"
RDEPEND="${DEPEND}
	app-editors/nedit
	dev-lang/tk
	dev-tcltk/blt
	media-fonts/font-sun-misc
	!sci-chemistry/sparta+
	!sci-chemistry/talos+
	sys-libs/ncurses:5/5
	x11-apps/xset
	|| ( x11-libs/xview x11-libs/xview-bin )
	!prefix? ( >=x11-libs/libX11-1.6.2[abi_x86_32(-)] )
	prefix? ( dev-util/patchelf )"

S="${WORKDIR}/NMR"

NMRBASE="/opt/${PN}"
ENMRBASE="${EPREFIX}/${NMRBASE}"

QA_PREBUILT="opt/.*"

src_unpack() {
	# The installation script will unpack the package. We just provide symlinks
	# to the archive files, ...
	for i in NMRPipeX-${PV}.tZ plugin.smile-${PV}.tZ talos-${PV}.tZ dyn-${PV}.tZ; do
		ln -sf "${DISTDIR}"/${i} ${i/-${PV}/} || die
	done
	mkdir "${S}" && cd "${S}" || die
	# ... copy the installation scripts ...
	cp -L "${DISTDIR}"/install-${PV}.com install.com || die
	cp -L "${DISTDIR}"/binval-${PV}.com binval.com || die
	# ... and make the installation scripts executable.
	chmod +x *.com || die
	VIRTUALX_COMMAND="csh"
	virtualmake \
		./install.com \
		+type $(usex x86 linux9 linux212_64) \
		+src "${WORKDIR}" \
		+dest "${S}" \
		+nopost +nocshrc
}

src_prepare() {
	local bin i
	epatch "${FILESDIR}"/${P}-lib.patch

	mv nmrbin.$(usex x86 linux9 linux212_64)/nmr{W,w}ish || die

	ebegin "Cleaning installation"

	# Remove some of the bundled applications and libraries; they are provided by Gentoo instead.
	rm -rf nmrbin.linux*/{lib/*.timestamp,*timestamp,xv,gnuplot*,rasmol*,nc,nedit} \
		nmrbin.{linux,mac} nmruser format \
		$(usex x86 nmrbin.linux212_64 nmrbin.linux9) \
		|| die "Failed to remove unnecessary libraries."
	# As long as xview is not fixed for amd64 we do this
	rm nmrbin.linux*/lib/{libxview.so*,libolgx.so*} || die
	# Remove the initialisation script generated during the installation.
	# It contains incorrect hardcoded paths; only the "nmrInit.com" script
	# should be used.
	rm -f com/nmrInit.linux*.com || die "Failed to remove broken init script."
	# Remove installation log files.
	rm -f README_NMRPIPE_USERS *.log install.com binval.com || die "Failed to remove installation log."
	# Remove unused binaries
	rm -f {talos*,spartaplus,promega}/bin/*{linux,mac,sgi6x,winxp} pdb/misc/addSeg || die

	# Some scripts are on the wrong place
	cp -f nmrtxt/*.com com/
	rm -f {acme,com}/{nmrproc,fid,install}.com || die
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
		-i $(find "${S}" \( -name "*.tcl" -o -name "*.com" -o -name "*.ksh" \)) \
			{com/,nmrtxt/*.com,nmrtxt/nt/*.com,dynamo/tcl/,talos*/com/,dynamo/tcl/}* \
			nmrbin.linux*/{nmrDraw,xNotify} || die
	eend

	if use prefix; then
		sed \
			-e "s: sh : \"${EPREFIX}/bin/sh\" :g" \
			-e "s: csh : \"${EPREFIX}/bin/csh\" :g" \
			-e "s: bash : \"${EPREFIX}/bin/bash\" :g" \
			-e "s:appTerm -e:appTerm -e \"${EPREFIX}/bin/csh\":g" \
			-i com/* || die

		ebegin "Setting RPATH in binaries"
		for bin in $(find nmrbin.linux*/ -type f -maxdepth 1); do
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
		-e "s:@BINTYPE@:$(usex x86 linux9 linux212_64):g" \
		"${FILESDIR}"/env-${PN} \
		> "${T}"/env-${PN} || die
	newenvd "${T}"/env-${PN} 40${PN}

	insinto ${NMRBASE}
	doins -r *

	dosym nmrbin.linux* ${NMRBASE}/bin

	ebegin "Fixing permissions"
	chmod 775 "${ED}"/${NMRBASE}/{talos*/bin/,sparta*/bin/,nmrbin.linux*/,com/,dynamo/tcl/,nmrtxt/*.com,talos*/com/,promega/bin/}* || die
	eend

	exeinto ${NMRBASE}/nmrbin.$(usex x86 linux9 linux212_64)
	doexe "${T}"/nmrWish

	insinto ${NMRBASE}/nmrtxt
	doins "${FILESDIR}"/extract.M
}
