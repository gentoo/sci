# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cuda eutils unpacker toolchain-funcs versionator

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)
DISTRO=fedora16-1

DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"
CURI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel-update-1/installers/"
SRC_URI="
	amd64? ( ${CURI}/cuda_${PV}_linux_64_${DISTRO}.run )
	x86? ( ${CURI}/cuda_${PV}_linux_32_${DISTRO}.run )"

LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +doc +examples opencl +cuda"

RDEPEND="
	>=dev-util/nvidia-cuda-toolkit-${PV}
	media-libs/freeglut
	examples? (
		media-libs/freeimage
		media-libs/glew
		>=x11-drivers/nvidia-drivers-304.54
		)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/sdk

src_unpack() {
	unpacker
	unpacker run_files/cuda-samples*run
}

pkg_setup() {
	if use cuda || use opencl; then
		cuda_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	sed \
		-e 's:-O2::g' \
		-e 's:-O3::g' \
		-e "/LINK/s:gcc:$(tc-getCC) ${LDFLAGS}:g" \
		-e "/LINK/s:g++:$(tc-getCXX) ${LDFLAGS}:g" \
		-e "/LINKFLAGS/s:=:= ${LDFLAGS} :g" \
		-e "/CC/s:gcc:$(tc-getCC):g" \
		-e "/GCC/s:g++:$(tc-getCXX):g" \
		-e "/NVCCFLAGS/s|\(:=\)|\1 ${NVCCFLAGS} |g" \
		-e "/ CFLAGS/s|\(:=\)|\1 ${CFLAGS}|g" \
		-e "/ CXXFLAGS/s|\(:=\)|\1 ${CXXFLAGS}|g" \
		-e 's:-Wimplicit::g' \
		-e "s|../../common/lib/linux/\$(OS_ARCH)/libGLEW.a|$(pkg-config --libs glew)|g" \
		-e "s|../../common/lib/\$(OSLOWER)/libGLEW.a|$(pkg-config --libs glew)|g" \
		-e "s|../../common/lib/\$(OSLOWER)/\$(OS_ARCH)/libGLEW.a|$(pkg-config --libs glew)|g" \
		-i $(find . -type f -name "Makefile") || die

	export LDFLAGS="$(raw-ldflags)"

	find common/inc/GL -delete || die
	find . -type f -name "*\.a" -delete || die
}

src_compile() {
	use examples || return
	local myopts verbose="verbose=1"
	use debug && myopts+=" dbg=1"
	emake \
		cuda-install="${EPREFIX}/opt/cuda" \
		CUDA_PATH="${EPREFIX}/opt/cuda/" \
		${myopts} ${verbose}
}

src_install() {
	local i j f t crap=""
	if use doc; then
		ebegin "Installing docs ..."
		dodoc -r doc releaseNotesData
		dohtml *htm*
		eend
	fi

	crap+=" *.txt doc Samples.htm* releaseNotesData"

	if ! use examples; then
		crap+=" */bin */tools"
	fi

	ebegin "Cleaning before installation..."
	find ${crap} -delete || die
	find . \( -name Makefile -o -name "*.mk" \) -delete || die
	eend

	ebegin "Moving files..."
	for f in $(find .); do
		local t="$(dirname ${f})"
		if [[ ${t/obj\/} != ${t} || ${t##*.} == a ]]; then
			continue
		fi
		if [[ ! -d ${f} ]]; then
			if [[ -x ${f} ]]; then
				exeinto /opt/cuda/sdk/${t}
				doexe ${f}
			else
				insinto /opt/cuda/sdk/${t}
				doins ${f}
			fi
		fi
	done
	eend
}
