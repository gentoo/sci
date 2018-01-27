# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=8676
INTEL_DIST_PV=2016_update2

inherit intel-sdp-r1

DESCRIPTION="Common libraries and utilities needed for Intel compilers and libraries"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-compilers/"

IUSE="+compiler doc examples mic mpi openmp l10n_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
REQUIRED_USE="mic? ( openmp )"

CHECKREQS_DISK_BUILD=750M

INTEL_DIST_BIN_RPMS=()
INTEL_DIST_DAT_RPMS=(
	"ccompxe-2016.2-062.noarch.rpm"
	"comp-l-all-common"
	"comp-l-all-vars"
	"comp-l-ps-common"
	"comp-ps-ss-doc-16.0.2-181.noarch.rpm")
INTEL_DIST_X86_RPMS=(
	"comp-l-all-32"
	"comp-l-ps-ss-wrapper")
INTEL_DIST_AMD64_RPMS=()

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"ccompxe-doc-2016.2-062.noarch.rpm")

		if use l10n_ja; then
			INTEL_DIST_DAT_RPMS+=(
				"comp-ps-doc-jp-16.0.2-181.noarch.rpm")
		fi
	fi

	if use examples; then
		INTEL_DIST_DAT_RPMS+=(
			"ccomp-doc-2016.2-062.noarch.rpm")
	fi

	if use mpi; then
		INTEL_DIST_X86_RPMS+=(
			"mpirt-l-ps-181-16.0.2-181.i486.rpm")
		INTEL_DIST_AMD64_RPMS+=(
			"mpi-psxe-062-5.1.3-062.x86_64.rpm"
			"mpi-rt-core-181-5.1.3-181.x86_64.rpm"
			"mpi-sdk-core-181-5.1.3-181.x86_64.rpm"
			)

		if use mic; then
			INTEL_DIST_AMD64_RPMS+=(
				"mpi-rt-mic-181-5.1.3-181.x86_64.rpm"
				"mpi-sdk-mic-181-5.1.3-181.x86_64.rpm")
		fi

		if use doc; then
			INTEL_DIST_AMD64_RPMS+=(
				"mpi-doc-5.1.3-181.x86_64.rpm")
		fi
	fi

	if use openmp; then
		INTEL_DIST_BIN_RPMS+=(
			"openmp-l-all"
			"openmp-l-ps")
		INTEL_DIST_AMD64_RPMS+=(
			"openmp-l-ps-ss")

		if use mic; then
			INTEL_DIST_AMD64_RPMS+=(
				"openmp-l-ps-mic")
		fi

		if use compiler; then
			INTEL_DIST_BIN_RPMS+=(
				"openmp-l-all-devel")
			INTEL_DIST_AMD64_RPMS+=(
				"openmp-l-ps-devel"
				"openmp-l-ps-ss-devel")

			if use l10n_ja; then
				INTEL_DIST_AMD64_RPMS+=(
					"openmp-l-ps-devel-jp")

				if use mic; then
					INTEL_DIST_AMD64_RPMS+=(
						"openmp-l-ps-mic-devel-jp")
				fi
			fi

			if use mic; then
				INTEL_DIST_AMD64_RPMS+=(
					"openmp-l-ps-mic-devel")
			fi
		fi

		if use l10n_ja; then
			INTEL_DIST_X86_RPMS+=(
				"openmp-l-ps-jp")
		fi
	fi

	if use compiler; then
		INTEL_DIST_BIN_RPMS+=(
			"comp-l-all-devel"
			"comp-l-ps-ss-devel")
		INTEL_DIST_AMD64_RPMS+=(
			"comp-l-ps-devel")
	fi
}

src_install() {
	intel-sdp-r1_src_install
	local path rootpath ldpath arch fenv=35intelsdp
	cat > ${fenv} <<-EOF
		NLSPATH=$(isdp_get-sdp-edir)/linux/compiler/lib/$(isdp_get-native-abi-arch)/locale/en_US/%N
		INTEL_LICENSE_FILE=${EPREFIX%/}/opt/intel/licenses:$(isdp_get-sdp-edir)/licenses
	EOF
	for arch in $(isdp_get-sdp-installed-arches); do
		path="${path}:$(isdp_get-sdp-edir)/linux/bin/${arch}"
		rootpath="${rootpath}:$(isdp_get-sdp-edir)/linux/bin/${arch}"
		ldpath="${ldpath}:$(isdp_get-sdp-edir)/linux/compiler/lib/${arch}"
	done
	if use mpi && use amd64; then
		path="${path}:$(isdp_get-sdp-edir)/linux/mpi/intel64/bin/"
		rootpath="${rootpath}:$(isdp_get-sdp-edir)/linux/mpi/intel64/bin/"
		ldpath="${ldpath}:$(isdp_get-sdp-edir)/linux/mpi/intel64/lib/"
	fi
	cat >> ${fenv} <<-EOF
		PATH=${path#:}
		ROOTPATH=${rootpath#:}
		LDPATH=${ldpath#:}
	EOF

	doenvd ${fenv}

	cat >> "${T}"/40-${PN} <<- EOF
	SEARCH_DIRS_MASK=$(isdp_get-sdp-edir)
	EOF
	insinto /etc/revdep-rebuild/
	doins "${T}"/40-${PN}
}
