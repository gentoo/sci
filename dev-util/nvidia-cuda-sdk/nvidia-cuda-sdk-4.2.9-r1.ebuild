# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cuda eutils unpacker toolchain-funcs versionator

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)
DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"
SRC_URI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel/sdk/gpucomputingsdk_${PV}_linux.run"

LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +doc +examples opencl +cuda"

RDEPEND="
	>=dev-util/nvidia-cuda-toolkit-${PV}
	media-libs/freeglut
	examples? (
			>=x11-drivers/nvidia-drivers-296
			media-libs/glew
		)"
DEPEND="${RDEPEND}"

S=${WORKDIR}

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
		-e "/CXX/s:g++:$(tc-getCXX):g" \
		-e "/NVCCFLAGS/s|\(:=\)|\1 ${NVCCFLAGS} |g" \
		-e "/ CFLAGS/s|\(:=\)|\1 ${CFLAGS}|g" \
		-e "/ CXXFLAGS/s|\(:=\)|\1 ${CXXFLAGS}|g" \
		-e 's:-Wimplicit::g' \
		-e 's:GLEW_x86_64:GLEW:g' \
		-i $(find sdk -type f -name "*.mk") || die

	find sdk/shared/inc/GL -delete || die
	find sdk -type f -name "*\.a" -delete || die
}

src_compile() {
	use examples || return
	local myopts verbose="verbose=1"
	use debug && myopts+=" dbg=1"
	cd sdk
	use cuda && emake -C C cuda-install="${EPREFIX}/opt/cuda" ${myopts} ${verbose}
	use opencl && emake -C OpenCL ${verbose}
}

src_install() {
	local i j f t crap=""
	cd sdk
	if use doc; then
		ebegin "Installing docs ..."
		for i in *; do
			if [[ -d ${i} ]]; then
				for j in doc releaseNotesData; do
					docinto ${i}
					[[ -d ${i}/${j} ]] && dodoc -r ${i}/${j}
				done
			fi
		done
		dodoc -r doc
		dohtml {.,*}/*htm*
		eend
	fi

	crap+=" *.txt doc */doc */Samples.htm* */releaseNotesData"

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
