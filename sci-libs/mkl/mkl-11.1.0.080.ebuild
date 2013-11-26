# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=3447
INTEL_DPV=2013_sp1
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp multilib alternatives-2

DESCRIPTION="Intel Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-mkl/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND=">=dev-libs/intel-common-13"

CHECKREQS_DISK_BUILD=2500M

INTEL_BIN_RPMS="
	mkl mkl-devel
	mkl-cluster mkl-cluster-devel
	mkl-f95-devel
	mkl-gnu mkl-gnu-devel
	mkl-pgi mkl-pgi-devel"
# single arch packages
#	mkl-mic mkl-mic-devel
#	mkl-sp2dp mkl-sp2dp-devel
INTEL_DAT_RPMS="mkl-common mkl-cluster-common mkl-f95-common"

src_prepare() {
	chmod u+w -R opt
}

mkl_add_prof() {
	local pcname=${1} libs cflags x
	shift
	[[ ${pcname} = *int64* ]] && cflags=-DMKL_ILP64
	cat <<-EOF > ${pcname}.pc
		prefix=${INTEL_SDP_EDIR}/mkl
		libdir=\${prefix}/lib/${IARCH}
		includedir=\${prefix}/include
		Name: ${pcname}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} ${libs}
		Cflags: -I\${includedir} ${cflags}
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${pcname}.pc
	for x in $*; do
		alternatives_for ${x} ${pcname/-${x}} 0 \
			/usr/$(get_libdir)/pkgconfig/${x}.pc ${pcname}.pc
	done
}

# mkl_prof [_ilp64 or _lp64]
# help: http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/
mkl_prof() {
	local bits=""
	if [[ ${IARCH} == intel64 ]]; then
		bits=_lp64
		[[ ${1} == int64 ]] && bits=_ilp64
	fi
	local gf="-Wl,--start-group -lmkl_gf${bits}"
	local intel="-Wl,--start-group -lmkl_intel${bits}"
	local core="-lmkl_core -Wl,--end-group"
	local prof=mkl${IARCH:((${#IARCH} - 2)):2}
	[[ ${1} == int64 ]] && prof=${prof}-int64
	local libs

	libs="${gf} -lmkl_sequential ${core} -lpthread" \
		mkl_add_prof ${prof}-gfortran blas lapack
	libs="${intel} -lmkl_sequential ${core} -lpthread" \
		mkl_add_prof ${prof}-intel blas lapack cblas lapacke
	libs="${gf} -lmkl_gnu_thread ${core} -fopenmp -lpthread" \
		mkl_add_prof ${prof}-gfortran-openmp blas lapack
	libs="${intel} -lmkl_gnu_thread ${core} -fopenmp -lpthread" \
		mkl_add_prof ${prof}-gcc-openmp cblas lapacke
	libs="${intel} -lmkl_intel_thread ${core} -openmp -lpthread" \
		mkl_add_prof ${prof}-intel-openmp blas lapack cblas lapacke
	libs="-lmkl_rt -lpthread" \
		mkl_add_prof ${prof}-dynamic blas lapack cblas lapacke
	libs="-lmkl_rt -liomp5 -lpthread" \
		mkl_add_prof ${prof}-dynamic-openmp blas lapack cblas lapacke

	# blacs and scalapack
	local scal="-lmkl_scalapack${bits:-_core}"
	local blacs="-lmkl_blacs_intelmpi${bits}"
	core="-lmkl_core ${blacs} -Wl,--end-group"

	libs="${gf} -lmkl_sequential ${core} -lpthread" \
		mkl_add_prof ${prof}-gfortran-blacs blacs
	libs="${scal} ${gf} -lmkl_sequential ${core} -lpthread" \
		mkl_add_prof ${prof}-gfortran-scalapack scalapack
	libs="${intel} -lmkl_sequential ${core} -lpthread" \
		mkl_add_prof ${prof}-intel-blacs blacs
	libs="${scal} ${intel} -lmkl_sequential ${core} -lpthread" \
		mkl_add_prof ${prof}-intel-scalapack scalapack
	libs="${gf} -lmkl_gnu_thread ${core} -fopenmp -lpthread" \
		mkl_add_prof ${prof}-gfortran-openmp-blacs blacs
	libs="${scal} ${gf} -lmkl_gnu_thread ${core} -fopenmp -lpthread" \
		mkl_add_prof ${prof}-gfortran-openmp-scalapack scalapack
	libs="${intel} -lmkl_gnu_thread ${core} -fopenmp -lpthread" \
		mkl_add_prof ${prof}-gcc-openmp-blacs blacs
	libs="${scal} ${intel} -lmkl_gnu_thread ${core} -fopenmp -lpthread" \
		mkl_add_prof ${prof}-gcc-openmp-scalapack scalapack
	libs="${intel} -lmkl_intel_thread ${core} -liomp5 -lpthread" \
		mkl_add_prof ${prof}-intel-openmp-blacs blacs
	libs="${scal} ${intel} -lmkl_intel_thread ${core} -liomp5 -lpthread" \
		mkl_add_prof ${prof}-intel-openmp-scalapack scalapack
	libs="-lmkl_rt ${blacs} -lpthread" \
		mkl_add_prof ${prof}-dynamic-blacs blacs
	libs="${scal} -lmkl_rt ${blacs} -lpthread" \
		mkl_add_prof ${prof}-dynamic-scalapack scalapack
	libs="-lmkl_rt ${blacs} -liomp5 -lpthread" \
		mkl_add_prof ${prof}-dynamic-openmp-blacs blacs
	libs="${scal} -lmkl_rt ${blacs} -liomp5 -lpthread" \
		mkl_add_prof ${prof}-dynamic-openmp-scalapack scalapack
}

src_install() {
	intel-sdp_src_install
	echo -n > 35mkl "LDPATH="
	for IARCH in ${INTEL_ARCH}; do
		mkl_prof
		sed -i -e '/mkl/s/$/:/' 35mkl
		echo -n >> 35mkl "${INTEL_SDP_EDIR}/mkl/lib/${IARCH}"
		[[ ${IARCH} == intel64 ]] && mkl_prof int64
	done
	echo >> 35mkl
	doenvd 35mkl
}
