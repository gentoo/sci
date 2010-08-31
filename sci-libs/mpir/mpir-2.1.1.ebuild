# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="MPIR is a library for arbitrary precision integer arithmetic derived from version 4.2.1 of gmp"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="+cxx cpudetection static-libs"

RESTRICT="mirror"

DEPEND="x86? ( dev-lang/yasm )
	amd64? ( dev-lang/yasm )"
RDEPEND=""

DOCS=( ChangeLog README NEWS )
PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-yasm.patch
	"${FILESDIR}"/${PN}-1.3.0-ABI-multilib.patch
)

src_prepare() {
	autotools-utils_src_prepare

	# FIXME: In the same way there was QA regarding executable stacks
	#        with GMP we have some here as well. We cannot apply the
	#        GMP solution as yasm is used, at least on x86/amd64.
	#        Furthermore we are able to patch config.ac.

	ebegin "Patching assembler files to remove executable sections"

	# TODO: report this to upstream
	# TODO: apply patch for all files ?
	# TODO: why does the as-style patch work (does mpir still use yasm ??)
	for i in $(find . -type f -name '*.asm') ; do
		# TODO: why does this not work without the following echo ???
		echo $i >/dev/null
		cat >> $i <<-EOF
			#if defined(__linux__) && defined(__ELF__)
			.section .note.GNU-stack,"",%progbits
			#endif
		EOF
	done

	for i in $(find . -type f -name '*.as') ; do
		echo $i >/dev/null
		cat >> $i <<-EOF
			%ifidn __OUTPUT_FORMAT__,elf
			section .note.GNU-stack noalloc noexec nowrite progbits
			%endif
		EOF
	done

	eend

	eautoreconf
}

src_configure() {
	# beware that cpudetection aka fat binaries is x86/amd64 only.
	# Place mpir in profiles/arch/$arch/package.use.mask when making it available on $arch.
	myeconfargs=(
		$(use_enable cxx) \
		$(use_enable cpudetection fat)
	)

	autotools-utils_src_configure
}

pkg_postinst() {
	elog "The mpir ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=293383"
	elog "This ebuild is known to have an executable stack problem on some CPUs"
}
