# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

release_data="20191120141844"
DESCRIPTION="Library for biobambam2"
HOMEPAGE="https://github.com/gt1/libmaus"
SRC_URI="https://gitlab.com/german.tischler/${PN}/-/archive/${PV}-release-${release_data}/${P}-release-${release_data}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 GPL-2 GPL-3 MIT ZLIB" # BUG: incomplete list of licenses, see AUTHORS
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2"

DEPEND="
	!sci-libs/libmaus
	>=sci-libs/io_lib-1.14.11
	app-arch/snappy
	sci-libs/fftw
	sci-libs/hdf5
	net-libs/gnutls
	dev-libs/nettle"
# --with-daligner
# --with-irods
# old github.com release tarballs
# S="${WORKDIR}"/libmaus2-master-27828cd78121d5e4b19c263c5527e462360f5901
# current gitlab.com release tarballs
S="${WORKDIR}/${P}-release-${release_data}"

src_configure(){
	local CONFIG_OPTS
	use cpu_flags_x86_ssse3 && CONFIG_OPTS+=( --enable-ssse3 )
	( use cpu_flags_x86_sse4_1 || use cpu_flags_x86_sse4_2 ) && CONFIG_OPTS+=( --enable-sse4 )
	econf --with-snappy --with-io_lib $CONFIG_OPTS \
		--with-lzma --with-gnutls --with-nettle --with-hdf5 --with-gmp --with-fftw
}

pkg_postinst(){
	einfo "The io_lib, snappy dependencies are not strictly needed"
	einfo "but were forced for optimal libmaus2 performance."
	einfo "igzip is only used if gzip level is set to 11."
}
