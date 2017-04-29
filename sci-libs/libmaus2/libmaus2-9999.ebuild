# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Library for biobambam2"
HOMEPAGE="https://github.com/gt1/libmaus"
EGIT_REPO_URI="https://github.com/gt1/libmaus2.git"

LICENSE="GPL-3" # BUG: a mix of licenses, see AUTHORS
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2"

DEPEND="
	!sci-libs/libmaus
	sci-libs/io_lib
	app-arch/snappy
	sci-biology/seqan
	sci-libs/fftw
	sci-libs/hdf5
	net-libs/gnutls
	dev-libs/nettle"
# --with-daligner
# --with-irods

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure(){
	local CONFIG_OPTS
	use cpu_flags_x86_ssse3 && CONFIG_OPTS+=( --enable-ssse3 )
	( use cpu_flags_x86_sse4_1 || use cpu_flags_x86_sse4_2 ) && CONFIG_OPTS+=( --enable-sse4 )
	econf --with-snappy --with-seqan --with-io_lib $CONFIG_OPTS \
		--with-lzma --with-gnutls --with-nettle --with-hdf5 --with-gmp --with-fftw
}

pkg_postinst(){
	einfo "The io_lib, snappy and seqan dependencies are not strictly needed"
	einfo "but were forced for optimal libmaus2 performance."
	einfo "igzip is only used if gzip level is set to 11."
}
