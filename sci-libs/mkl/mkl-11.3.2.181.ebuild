# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=8676
INTEL_DIST_PV=2016_update2
INTEL_SKIP_LICENSE=true

NUMERIC_MODULE_NAME=${PN}

inherit alternatives-2 intel-sdp-r1 numeric-int64-multibuild

DESCRIPTION="Intel Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-mkl/"

IUSE="doc examples linguas_ja mic"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND=">=dev-libs/intel-common-16[${MULTILIB_USEDEP},mic?]"

CHECKREQS_DISK_BUILD=3500M

INTEL_DIST_BIN_RPMS=(
	"mkl"
	"mkl-devel"
	"mkl-gnu"
	"mkl-gnu-devel"
	"mkl-ps"
	"mkl-ps-f95-devel"
	"mkl-ps-gnu"
	"mkl-ps-gnu-devel"
	"mkl-ps-pgi"
	"mkl-ps-pgi-devel"
	"mkl-ps-ss-tbb"
	"mkl-ps-ss-tbb-devel")
INTEL_DIST_X86_RPMS=()
INTEL_DIST_AMD64_RPMS=(
	"mkl-ps-cluster"
	"mkl-ps-cluster-devel"
	"mkl-sp2dp"
	"mkl-sp2dp-devel")
INTEL_DIST_DAT_RPMS=(
	"mkl-common"
	"mkl-ps-cluster-common"
	"mkl-ps-common"
	"mkl-ps-f95-common")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"mkl-doc-11.3.2-181.noarch.rpm"
			"mkl-ps-doc-11.3.2-181.noarch.rpm")

		if use linguas_ja; then
			INTEL_DIST_DAT_RPMS+=(
				"mkl-ps-doc-jp-11.3.2-181.noarch.rpm")
		fi
	fi

	if use mic; then
		INTEL_DIST_AMD64_RPMS+=(
			"mkl-ps-mic"
			"mkl-ps-mic-devel"
			"mkl-ps-tbb-mic"
			"mkl-ps-tbb-mic-devel")
	fi

	if use linguas_ja; then
		INTEL_DIST_BIN_RPMS+=(
			"mkl-ps-jp")

		INTEL_DIST_DAT_RPMS+=(
			"mkl-ps-common-jp")

		if use mic; then
			INTEL_DIST_AMD64_RPMS+=(
				"mkl-ps-mic-jp")
		fi
	fi
}

src_prepare() {
	default
	chmod u+w -R opt || die
}

_mkl_add_pc_file() {
	local pcname=${1} cflags="" suffix=""
	shift
	numeric-int64_is_int64_build && cflags=-DMKL_ILP64 && suffix="-int64"

	local IARCH=$(isdp_convert2intel-arch ${MULTIBUILD_ID})

	create_pkgconfig \
		--prefix "$(isdp_get-sdp-edir)/linux/mkl" \
		--libdir "\${prefix}/lib/${IARCH}" \
		--includedir "\${prefix}/include" \
		--name ${pcname} \
		--libs "-L\${libdir} -L$(isdp_get-sdp-edir)/linux/compiler/lib/${IARCH} $* -lpthread -lm" \
		--cflags "-I\${includedir} ${cflags}" \
		${pcname}${suffix}
}

_mkl_add_alternative_provider() {
	local prov=$1; shift
	local alt
	for alt in $*; do
		NUMERIC_MODULE_NAME=${prov} \
			numeric-int64-multibuild_install_alternative ${alt} ${prov}
	done
}

# help: http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/
mkl_add_pc_file() {
	local bits=""
	[[ ${MULTIBUILD_ID} =~ amd64 ]] && bits=_lp64
	numeric-int64_is_int64_build && bits=_ilp64

	local gf="-Wl,--no-as-needed -Wl,--start-group -lmkl_gf${bits}"
	local gc="-Wl,--no-as-needed -Wl,--start-group -lmkl_intel${bits}"
	local intel="-Wl,--start-group -lmkl_intel${bits}"
	local core="-lmkl_core -Wl,--end-group"

	# blas lapack cblas lapacke
	_mkl_add_pc_file mkl-gfortran ${gf} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-intel ${intel} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-gfortran-openmp ${gf} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gcc-openmp ${gc} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-intel-openmp ${intel} -lmkl_intel_thread ${core} -openmp
	_mkl_add_pc_file mkl-dynamic -lmkl_rt
	_mkl_add_pc_file mkl-dynamic-openmp -lmkl_rt -liomp5

	# blacs and scalapack
	local scal="-lmkl_scalapack${bits:-_core}"
	local blacs="-lmkl_blacs_intelmpi${bits}"
	core="-lmkl_core ${blacs} -Wl,--end-group"

	_mkl_add_pc_file mkl-gfortran-blacs ${gf} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-gfortran-scalapack ${scal} ${gf} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-intel-blacs ${intel} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-intel-scalapack ${scal} ${intel} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-gfortran-openmp-blacs ${gf} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gfortran-openmp-scalapack ${scal} ${gf} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gcc-openmp-blacs ${gc} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gcc-openmp-scalapack ${scal} ${gc} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-intel-openmp-blacs ${intel} -lmkl_intel_thread ${core} -liomp5
	_mkl_add_pc_file mkl-intel-openmp-scalapack ${scal} ${intel} -lmkl_intel_thread ${core} -liomp5
	_mkl_add_pc_file mkl-dynamic-blacs -lmkl_rt ${blacs}
	_mkl_add_pc_file mkl-dynamic-scalapack ${scal} -lmkl_rt ${blacs}
	_mkl_add_pc_file mkl-dynamic-openmp-blacs -lmkl_rt ${blacs} -liomp5
	_mkl_add_pc_file mkl-dynamic-openmp-scalapack ${scal} -lmkl_rt ${blacs} -liomp5
}

mkl_add_alternative_provider() {
	# blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-gfortran blas lapack
	_mkl_add_alternative_provider mkl-intel blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-gfortran-openmp blas lapack
	_mkl_add_alternative_provider mkl-gcc-openmp cblas lapacke
	_mkl_add_alternative_provider mkl-intel-openmp blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-dynamic blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-dynamic-openmp blas lapack cblas lapacke

	# blacs and scalapack
	_mkl_add_alternative_provider mkl-gfortran-blacs blacs
	_mkl_add_alternative_provider mkl-gfortran-scalapack scalapack
	_mkl_add_alternative_provider mkl-intel-blacs blacs
	_mkl_add_alternative_provider mkl-intel-scalapack scalapack
	_mkl_add_alternative_provider mkl-gfortran-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-gfortran-openmp-scalapack scalapack
	_mkl_add_alternative_provider mkl-gcc-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-gcc-openmp-scalapack scalapack
	_mkl_add_alternative_provider mkl-intel-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-intel-openmp-scalapack scalapack
	_mkl_add_alternative_provider mkl-dynamic-blacs blacs
	_mkl_add_alternative_provider mkl-dynamic-scalapack scalapack
	_mkl_add_alternative_provider mkl-dynamic-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-dynamic-openmp-scalapack scalapack
}

src_install() {
	local IARCH
	local ldpath="LDPATH="
	intel-sdp-r1_src_install

	numeric-int64-multibuild_foreach_all_abi_variants mkl_add_pc_file
	mkl_add_alternative_provider

	use abi_x86_64 && ldpath+=":$(isdp_get-sdp-edir)/linux/mkl/lib/$(isdp_convert2intel-arch abi_x86_64)"
	use abi_x86_32 && ldpath+=":$(isdp_get-sdp-edir)/linux/mkl/lib/$(isdp_convert2intel-arch abi_x86_32)"

	echo "${ldpath}" > "${T}"/35mkl || die
	doenvd "${T}"/35mkl
}
