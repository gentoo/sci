# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=7538
INTEL_DPV=2015_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false
INTEL_SKIP_LICENSE=true

NUMERIC_MODULE_NAME=${PN}

inherit alternatives-2 intel-sdp numeric-int64-multibuild

DESCRIPTION="Intel Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-mkl/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND=">=dev-libs/intel-common-15[${MULTILIB_USEDEP}]"

CHECKREQS_DISK_BUILD=2500M

INTEL_BIN_RPMS=(
	mkl mkl-devel
	mkl-cluster mkl-cluster-devel
	mkl-f95-devel
	mkl-gnu mkl-gnu-devel
	mkl-pgi mkl-pgi-devel
	)
INTEL_AMD64_RPMS=(
	mkl-mic mkl-mic-devel
	mkl-sp2dp mkl-sp2dp-devel
	)
INTEL_DAT_RPMS=(
	mkl-common
	mkl-cluster-common
	mkl-f95-common
	)

pkg_setup() {
	intel-sdp_pkg_setup
}

src_prepare() {
	chmod u+w -R opt || die
}

_mkl_add_pc_file() {
	local pcname=${1} cflags="" suffix=""
	shift
	numeric-int64_is_int64_build && cflags=-DMKL_ILP64 && suffix="-int64"

	local IARCH=$(convert2intel_arch ${MULTIBUILD_ID})

	create_pkgconfig \
		--prefix "${INTEL_SDP_EDIR}/mkl" \
		--libdir "\${prefix}/lib/${IARCH}" \
		--includedir "\${prefix}/include" \
		--name ${pcname} \
		--libs "-L\${libdir} -L${INTEL_SDP_EDIR}/compiler/lib/${IARCH} $* -lpthread -lm" \
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
	intel-sdp_src_install

	numeric-int64-multibuild_foreach_all_abi_variants mkl_add_pc_file
	mkl_add_alternative_provider

	use abi_x86_64 && ldpath+="${INTEL_SDP_EDIR}/mkl/lib/$(convert2intel_arch abi_x86_64)"
	use abi_x86_32 && ldpath+=":${INTEL_SDP_EDIR}/mkl/lib/$(convert2intel_arch abi_x86_32)"

	echo "${ldpath}" > "${T}"/35mkl || die
	doenvd "${T}"/35mkl
}
