# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils portability toolchain-funcs unpacker versionator

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)

DESCRIPTION="NVIDIA GPU Deployment Kit"
HOMEPAGE="https://developer.nvidia.com/gpu-deployment-kit"
CURI="http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers"
SRC_URI="
	amd64? ( ${CURI}/cuda_${MYD}_gdk_linux_64.run )
	x86? ( ${CURI}/cuda_${MYD}_gdk_linux_32.run )"

LICENSE="NVIDIA-gdk"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+healthmon +nvml +doc examples"

RDEPEND="
	>=dev-util/nvidia-cuda-toolkit-6.5
	media-libs/freeglut
	examples? ( >=x11-drivers/nvidia-drivers-340.32[uvm] )
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/payload"

QA_PREBUILT="/opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon
	/opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon-tests/gpu_rdma_bw
	/opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon-tests/ibv_rdma_bw
	/opt/cuda/gdk/nvml/lib/libnvidia-ml.so.1"

src_unpack() {
	unpacker
}

src_compile() {
	use examples || return
	cd "${S}"/nvml/example || die
	default
}

src_install() {
	local i j f t _arch
	if use amd64; then
		_arch=amd64;
	elif use x86; then
		_arch=x86;
	else
		die;
	fi

	if use doc; then
		if use healthmon ; then
			ebegin "Installing healthmon docs..."
				doman nvidia-healthmon/docs/man/man8/nvidia-healthmon.8
				cd "${S}/nvidia-healthmon/nvidia-healthmon-${_arch}-${PV}" || die
				treecopy \
					$(find -type f \( -name README.txt -name COPYING.txt -o -name "*.pdf" \)) \
					"${ED}"/usr/share/doc/${PF}/nvidia-healthmon/
				docompress -x \
					$(find "${ED}"/usr/share/doc/${PF}/nvidia-healthmon/ -type f -name readme.txt | sed -e "s:${ED}::")
				cd "${S}/" || die
			eend
		fi

		if use nvml ; then
			ebegin "Installing nvml docs..."
				doman nvml/doc/man/man3/*.3
				cd "${S}/nvml/" || die
				treecopy \
					$(find -type f \( -name README.txt -name COPYRIGHT.txt -o -name "*.pdf" \)) \
					"${ED}"/usr/share/doc/${PF}/nvml/
				docompress -x \
					$(find "${ED}"/usr/share/doc/${PF}/nvml/ -type f -name readme.txt | sed -e "s:${ED}::")
				cd "${S}/" || die
			eend
		fi
	fi

	ebegin "Cleaning before installation..."
		find -type f \
			\( -name "*.o" -o -name "*.pdf" -o -name "*.txt" -o -name "*.3" \) -delete \
			|| die
		rm -f "${S}"/nvml/lib/libnvidia-ml.so
	eend

	if use healthmon; then
		ebegin "Installing nvidia-healthmon"
			exeinto /opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon-tests/
			doexe "nvidia-healthmon/nvidia-healthmon-${_arch}-${PV}/bin"/{*,*.*}
			exeinto /opt/cuda/gdk/nvidia-healthmon/
			doexe "nvidia-healthmon/nvidia-healthmon-${_arch}-${PV}"/nvidia-healthmon
			insinto /etc/nvidia-healthmon/
			doins "nvidia-healthmon/nvidia-healthmon-${_arch}-${PV}"/nvidia-healthmon.conf

			# install launch script
			exeinto /opt/bin
			doexe "${FILESDIR}"/nvidia-healthmon
		eend
	fi

	if use nvml; then
		ebegin "Installing nvml"
			cd "${S}/nvml" || die
			for f in $(find .); do
				local t="$(dirname ${f})"
				if [[ "${t/obj\/}" != "${t}" || "${t##*.}" == "a" ]]; then
					continue
				fi

				if [[ ! -d "${f}" ]]; then
					if [[ -x "${f}" ]]; then
						exeinto "/opt/cuda/gdk/nvml/${t}"
						doexe "${f}"
					else
						insinto "/opt/cuda/gdk/nvml/${t}"
						doins "${f}"
					fi
				fi
			done

			dosym libnvidia-ml.so.1 /opt/cuda/gdk/nvml/lib/libnvidia-ml.so
			cd "${S}/" || die
		eend
	fi
}
