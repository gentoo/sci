# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Spectral visualisation, analysis and Fourier processing"
# The specific terms of this license are printed automatically on startup
# by some NMRPipe applications. The user also has to accept them before
# downloading the package.
LICENSE="as-is"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/NMRPipe/"
# The NMRPipe installation script which we are not allowed to modify
# requires all the following to be present for a complete installation.
# Many of the bundled applications and libraries are afterwards deleted
# (by this ebuild). The Gentoo provided applications and libraries are
# used instead. The notable exception is the Tcl/Tk libraries; NMRPipe
# requires a modified version of these. Unfortunately, this requires to
# redefine the location of the libraries, which is done by sourcing an
# initialisation script. NMRPipe users are used to this, and this ebuild
# also prints a notice to this effect.
SRC_URI="${PN}.linux9.tar.Z
	dyn.tar.Z
	mfr.tar.Z
	pdbH.tar.Z
	valpha.tar
	acme.tar.Z
	binval.com
	install.com"

SLOT="0"
IUSE=""
# Right now, precompiled executables are only available for Linux on the
# x86 architecture. The maintainer chose to keep the sources closed, but
# says he will gladly provide precompiled executables for other platforms
# if there are such requests.
KEYWORDS="-* ~x86"

# The maintainer absolutely wants to control redistribution.
RESTRICT="fetch"

DEPEND="app-shells/tcsh"

RDEPEND="${DEPEND}
	dev-lang/tcl
	dev-lang/tk
	dev-tcltk/blt
	sys-libs/libtermcap-compat
	sys-libs/ncurses
	x11-libs/xview
	x11-libs/libX11"

S="${WORKDIR}"
NMRBASE="/opt/${PN}"

pkg_nofetch() {
	einfo "Please visit:"
	einfo "\t${HOMEPAGE}"
	einfo
	einfo "Contact the package maintainer, then download the following files:"
	for i in ${A}; do
		einfo "\t${i}"
	done
	einfo
	einfo "Place the downloaded files in your distfiles directory:"
	einfo "\t${DISTDIR}"
	echo
}

src_unpack() {
	# The installation script will unpack the package. We just provide symlinks
	# to the archive files, ...
	for i in ${PN}.linux9.tar.Z dyn.tar.Z mfr.tar.Z \
			pdbH.tar.Z valpha.tar acme.tar.Z; do
		ln -s "${DISTDIR}"/${i} ${i}
	done
	# ... copy the installation scripts ...
	cp "${DISTDIR}"/{binval.com,install.com} .
	# ... and make the installation scripts executable.
	chmod +x binval.com install.com
}

src_compile() {
	# Unset DISPLAY to avoid the interactive graphical test.
	DISPLAY="" ./install.com "${S}" || die
	# Remove the symlinks for the archives and the installation scripts.
	for i in ${A}; do
		rm ${i} || die "Failed to remove archive symlinks."
	done
	# Remove some of the bundled applications and libraries; they are
	# provided by Gentoo instead.
	rm -r nmrbin.linux9/{0.0,lib,*timestamp,xv,gnuplot*,rasmol*} \
		|| die "Failed to remove unnecessary libraries."
	# Remove the initialisation script generated during the installation.
	# It contains incorrect hardcoded paths; only the "nmrInit.com" script
	# should be used.
	rm com/nmrInit.linux9.com || die "Failed to remove broken init script."
	# Make the precompiled Linux binaries executable.
	chmod +x nmrbin.linux9/* || die "Failed to make programs executable."
	# Set the correct path to NMRPipe in the auxiliary scripts.
	cd com
	for i in *; do
		sed -e "s%/u/delaglio%${NMRBASE}%" -i ${i} || die \
			"Failed patching scripts."
	done
	sed -i "s:${WORKDIR}:${NMRBASE}:g" font.com
	# Remove installation log files.
	cd "${S}"
	rm *.log || die "Failed to remove installation log."
}

src_install() {
	newenvd "${FILESDIR}"/env-${PN} 40${PN} || die "Failed to install env file."
	insinto ${NMRBASE}
	insopts -m0755
	doins -r * || die "Failed to install application."
	dosym ${NMRBASE}/nmrbin.linux9 ${NMRBASE}/bin || die \
		"Failed to symlink binaries."
}

pkg_postinst() {
	echo
	ewarn "Before using NMRPipe applications, users must source the following"
	ewarn "csh script, which will set the necessary environment variables:"
	ewarn "\t${NMRBASE}/com/nmrInit.com"
	ewarn
	ewarn "Be aware that this script redefines the locations of the Tcl"
	ewarn "libraries. This could break other non-NMRPipe Tcl applications"
	ewarn "run in the same session."
	ewarn
	ewarn "Using Dynamo does not require running an additional initialisation"
	ewarn "script. The necessary environment variables should already be set."
	echo
}
