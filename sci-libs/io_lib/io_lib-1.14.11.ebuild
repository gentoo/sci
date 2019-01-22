# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils eutils versionator
MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="General purpose trace and experiment file reading/writing interface"
HOMEPAGE="https://github.com/jkbonfield/io_lib
	http://staden.sourceforge.net/"
SRC_URI="https://github.com/jkbonfield/io_lib/archive/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+bzip2 curl +libdeflate lzma static-libs"

S="${WORKDIR}"/"${PN}-${PN}-${MY_PV}"

# >>> Working in BUILD_DIR: "/scratch/var/tmp/portage/sci-libs/io_lib-1.14.11/work/io_lib-1.14.11_build"
# /scratch/var/tmp/portage/sci-libs/io_lib-1.14.11/temp/environment: line 530: pushd: /scratch/var/tmp/portage/sci-libs/io_lib-1.14.11/work/io_lib-1.14.11_build: No such file or directory
#  * ERROR: sci-libs/io_lib-1.14.11::science failed (install phase):
#  *   (no error message)
#  * 
#  * Call stack:
#  *     ebuild.sh, line  124:  Called src_install
#  *   environment, line 2506:  Called autotools-utils_src_install
#  *   environment, line  530:  Called die
#  * The specific snippet of code:
#  *       pushd "${BUILD_DIR}" > /dev/null || die;
# 
BUILD_DIR="${S}"

# Prototype changes in io_lib-1.9.0 create incompatibilities with BioPerl. (Only
# versions 1.8.11 and 1.8.12 will work with the BioPerl Staden extensions.)
#DEPEND="!sci-biology/bioperl"
DEPEND="
	libdeflate? ( app-arch/libdeflate )
	lzma? ( app-arch/xz-utils:= app-arch/lzma )
	bzip2? ( app-arch/bzip2 )
	curl? ( net-misc/curl )
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare(){
	# https://github.com/jkbonfield/io_lib/issues/12
	eautoreconf
	default
}

src_configure(){
	# https://github.com/jkbonfield/io_lib/issues/11
	# https://github.com/jkbonfield/io_lib/issues/13
	local myconf=()
	! use static-libs && myconf+=( "--enable-static=no" )
	econf ${myconf[@]} $(use_with libdeflate)
}

src_compile(){
	# BUG: "have to" provide my own src_compile() because ${P}_build dir is missing now
	# alternatively BUILD_DIR="${S}" would probably help here too
	emake
}

src_install() {
	# cd "${S}" || die # this does not help to get around the ${P}_build missing
	# what helped was to set BUILD_DIR="${S}" above
	autotools-utils_src_install
	dodoc docs/{Hash_File_Format,ZTR_format}
}
