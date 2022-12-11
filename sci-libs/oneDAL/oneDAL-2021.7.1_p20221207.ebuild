# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-any-r1 java-pkg-2

# Latest from development required to build using open source DPC++
COMMIT="a6bce46565825747fa8c3fdfe2dd6a676ab600a7"

MKLFPK_VER="20210426"
MKLGPUFPK_VER="2021-11-11"

DESCRIPTION="oneAPI Data Analytics Library"
HOMEPAGE="https://github.com/oneapi-src/oneDAL"
# Secondary urls extracted from dev/download_micromkl.sh
SRC_URI="
	https://github.com/oneapi-src/oneDAL/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/oneapi-src/oneDAL/releases/download/Dependencies/mklgpufpk_lnx_${MKLGPUFPK_VER}.tgz
	https://github.com/oneapi-src/oneDAL/releases/download/Dependencies/mklfpk_lnx_${MKLFPK_VER}.tgz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="sys-devel/DPC++"

RDEPEND="
	dev-cpp/tbb:=
	dev-libs/opencl-icd-loader
	virtual/jdk:17
"
DEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}/${P}-fix-compile.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack "${P}.tar.gz"
	mkdir -p "${S}/__deps/mklfpk/" "${S}/__deps/mklgpufpk/lnx" || die
	cd "${S}/__deps/mklfpk/" || die
	unpack "mklfpk_lnx_${MKLFPK_VER}.tgz"
	cd "${S}/__deps/mklgpufpk/lnx" || die
	unpack "mklgpufpk_lnx_${MKLGPUFPK_VER}.tgz"
}

src_prepare() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export TBBROOT="${ESYSROOT}/usr"
	export CPLUS_INCLUDE_PATH="./cpp/daal/include:${ESYSROOT}/usr/lib/llvm/intel/include"
	export JAVA_HOME="${ESYSROOT}/usr/lib64/openjdk-17/"
	export PATH="${JAVA_HOME}/bin:${PATH}"
	export CPATH="${JAVA_HOME}/include:${JAVA_HOME}/include/linux:${CPATH}"

	default
}

src_compile() {
	emake PLAT=lnx32e COMPILER=icx daal oneapi
}

src_install() {
	einstalldocs
	cd __release_lnx_icx/daal/latest || die
	docinto examples
	dodoc -r examples/*
	docinto samples
	dodoc -r samples/*
	doheader -r include/*
	dolib.so lib/intel64/*.so*
	dolib.a lib/intel64/*.a*
	insinto /usr/share/pkgconfig
	doins -r lib/pkgconfig/*
	java-pkg_dojar lib/*.jar
}
