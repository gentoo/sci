# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/axiom/axiom-200805.ebuild,v 1.6 2008/08/30 13:17:33 markusle Exp $

inherit eutils flag-o-matic multilib

DESCRIPTION="Axiom is a general purpose Computer Algebra system"
HOMEPAGE="http://axiom.axiom-developer.org/"
SRC_URI="http://www.axiom-developer.org/axiom-website/downloads/${PN}-sept2010-src.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# NOTE: Do not strip since this seems to remove some crucial
# runtime paths as well, thereby, breaking axiom
RESTRICT="strip"

# Seems to need a working version of pstricks package these days Bummer: <gmp-5 is needed for the
# interal gcl, otherwise axiom will try to build an internal copy of gmp-4 which fails.
RDEPEND="
	dev-libs/gmp
	x11-libs/libXaw"
DEPEND="${RDEPEND}
	app-text/dvipdfm
	dev-texlive/texlive-pstricks
	sys-apps/debianutils
	sys-process/procps
	virtual/latex-base"

S="${WORKDIR}"/${PN}

## The following stuff seems to be fixed?

# pkg_setup() {
# 	# for 2.6.25 kernels and higher we need to have
# 	# /proc/sys/kernel/randomize_va_space set to somthing other
# 	# than 2, otherwise gcl fails to compile (see bug #186926).
# 	local current_setting=$(/sbin/sysctl kernel.randomize_va_space 2>/dev/null | cut -d' ' -f3)
# 	if [[ ${current_setting} == 2 ]]; then
# 		echo
# 		eerror "Your kernel has brk randomization enabled. This will"
# 		eerror "cause axiom to fail to compile *and* run (see bug #186926)."
# 		eerror "You can issue:"
# 		eerror
# 		eerror "   /sbin/sysctl -w kernel.randomize_va_space=1"
# 		eerror
# 		eerror "as root to turn brk randomization off temporarily."
# 		eerror "However, when not using axiom you may want to turn"
# 		eerror "brk randomization back on via"
# 		eerror
# 		eerror "   /sbin/sysctl -w kernel.randomize_va_space=2"
# 		eerror
# 		eerror "since it results in a less secure kernel."
# 		die "Kernel brk randomization detected"
# 	fi
# }

src_unpack() {
	unpack ${A}
	cd "${S}"

	## How weird, axiom ships these patches, but does not apply them.
	## So, we keep our gentoo patches around.
	cp "${FILESDIR}"/noweb-2.9-insecure-tmp-file.patch.input \
		"${S}"/zips/noweb-2.9-insecure-tmp-file.patch \
		|| die "Failed to fix noweb"
# 	cp "${FILESDIR}"/${PN}-200711-gcl-configure.patch \
# 		"${S}"/zips/gcl-2.6.7.configure.in.patch \
# 		|| die "Failed to fix gcl-2.6.7 configure"
	epatch "${FILESDIR}"/noweb-2.9-insecure-tmp-file.Makefile.patch \
		|| die "Failed to patch noweb security issue!"
}

src_compile() {
	# lots of strict-aliasing badness
	append-flags -fno-strict-aliasing

	econf || die "Failed to configure"

## I believe 2.6.8_pre4 can be used now.
	# use gcl 2.6.7
#	sed -e "s:GCLVERSION=gcl-2.6.8pre$:GCLVERSION=gcl-2.6.7:" \
#		-i Makefile.pamphlet Makefile \
#		|| die "Failed to select proper gcl"
#
	# fix libXpm.a location
	sed -e "s:X11R6/lib:$(get_libdir):g" -i Makefile.pamphlet \
		|| die "Failed to fix libXpm lib paths"

	# This will fix the internal gmp. This package will stay unkeyworded until this is resolved
	# upstream.
	unset ABI

	# Let the fun begin...
	AXIOM="${S}"/mnt/linux emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}"/opt/axiom COMMAND="${D}"/opt/axiom/mnt/linux/bin/axiom install \
		|| die 'Failed to install Axiom!'

	mv "${D}"/opt/axiom/mnt/linux/* "${D}"/opt/axiom \
		|| die "Failed to mv axiom into its final destination path."
	rm -fr "${D}"/opt/axiom/mnt \
		|| die "Failed to remove old directory."

	dodir /usr/bin
	dosym /opt/axiom/bin/axiom /usr/bin/axiom

	sed -e "2d;3i AXIOM=/opt/axiom" \
		-i "${D}"/opt/axiom/bin/axiom \
		|| die "Failed to patch axiom runscript!"

	dodoc changelog readme faq
}
