# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils portability toolchain-funcs unpacker versionator

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)

HEALTMON_PV="${PV}"
NVVS_PV="${PV}"

DESCRIPTION="NVIDIA GPU Deployment Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"
SRC_URI="http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_${MYD}_gdk_linux.run"

LICENSE="NVIDIA-gdk"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+healthmon +nvml +doc examples +nvvs"

RDEPEND="
	>=dev-util/nvidia-cuda-toolkit-7.5
	media-libs/freeglut
	examples? ( >=x11-drivers/nvidia-drivers-352.79[uvm] )
	nvvs? (
		>=x11-drivers/nvidia-drivers-352.79[uvm]
		<x11-drivers/nvidia-drivers-355.00[uvm]
	)
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/payload"

QA_PREBUILT=(
	/opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon
	/opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon-tests/gpu_rdma_bw
	/opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon-tests/ibv_rdma_bw
	/opt/cuda/gdk/nvml/lib/libnvidia-ml.so.1
	/opt/cuda/gdk/nvvs/plugins/libPcie.so.1
	/opt/cuda/gdk/nvvs/plugins/libSmPerformance.so.1
	/opt/cuda/gdk/nvvs/plugins/libPerformance.so
	/opt/cuda/gdk/nvvs/plugins/libPower.so.1
	/opt/cuda/gdk/nvvs/plugins/libMemory.so.1
	/opt/cuda/gdk/nvvs/plugins/libPerformance.so.1
	/opt/cuda/gdk/nvvs/plugins/libDeployment.so.1
	/opt/cuda/gdk/nvvs/plugins/libSmPerformance.so
	/opt/cuda/gdk/nvvs/plugins/libPower.so
	/opt/cuda/gdk/nvvs/nvvs
)

src_unpack() {
	unpacker
}

src_compile() {
	use examples || return
	cd "${S}"/nvml/example || die
	default
}

src_install() {
	local i j f t

	if use doc; then
		if use healthmon ; then
			ebegin "Installing healthmon docs..."
				doman nvidia-healthmon/docs/man/man8/nvidia-healthmon.8
				cd "${S}/nvidia-healthmon/nvidia-healthmon-amd64-${HEALTMON_PV}" || die
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

		if use nvvs ; then
			ebegin "Installing validation suite docs..."
				dodoc "nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/docs/NVIDIA_Validation_Suite_User_Guide.pdf"
				doman "nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/docs/man/man8/nvvs.8"
			eend
		fi

	fi

	ebegin "Cleaning before installation..."
		find -type f \
			\( -name "*.o" -o -name "*.pdf" -o -name "*.txt" -o -name "*.3" -o -name "*.8" \) -delete \
			|| die
		rm -f "${S}"/nvml/lib/libnvidia-ml.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/plugins"/libDeployment.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/plugins"/libMemory.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/plugins"/libPcie.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/plugins"/libPerformance.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/plugins"/libPower.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/plugins"/libSmPerformance.so
		rm -f "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}"/nvidia-vs
	eend

	if use healthmon; then
		ebegin "Installing nvidia-healthmon"
			exeinto /opt/cuda/gdk/nvidia-healthmon/nvidia-healthmon-tests/
			doexe "nvidia-healthmon/nvidia-healthmon-amd64-${HEALTMON_PV}/bin"/{*,*.*}
			exeinto /opt/cuda/gdk/nvidia-healthmon/
			doexe "nvidia-healthmon/nvidia-healthmon-amd64-${HEALTMON_PV}"/nvidia-healthmon
			insinto /etc/nvidia-healthmon/
			doins "nvidia-healthmon/nvidia-healthmon-amd64-${HEALTMON_PV}"/nvidia-healthmon.conf

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

	if use nvvs; then
		ebegin "Installing validation suite"
			cd "${S}/nvidia-validation-suite/nvidia-validation-suite-amd64-${NVVS_PV}/" || die

			insinto /etc/nvidia-validation-suite/
			doins nvvs.conf
			rm nvvs.conf || die

			for f in $(find .); do
				local t="$(dirname ${f})"
				if [[ "${t/obj\/}" != "${t}" || "${t##*.}" == "a" ]]; then
					continue
				fi

				if [[ ! -d "${f}" ]]; then
					if [[ -x "${f}" ]]; then
						exeinto "/opt/cuda/gdk/nvvs/${t}"
						doexe "${f}"
					else
						insinto "/opt/cuda/gdk/nvvs/${t}"
						doins "${f}"
					fi
				fi
			done

			dosym libDeployment.so.1 /opt/cuda/gdk/nvvs/plugins/libDeployment.so
			dosym libMemory.so.1 /opt/cuda/gdk/nvvs/plugins/libMemory.so
			dosym libPcie.so.1 /opt/cuda/gdk/nvvs/plugins/libPcie.so
			dosym libPerformance.so.1 /opt/cuda/gdk/nvvs/plugins/libPerformance.so
			dosym libPower.so.1 /opt/cuda/gdk/nvvs/plugins/libPower.so
			dosym libSmPerformance.so.1 /opt/cuda/gdk/nvvs/plugins/libSmPerformance.so

			dosym ../cuda/gdk/nvvs/nvvs /opt/bin/nvidia-vs
		eend
	fi
}
