# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/hip"

PATCHES=( "${FILESDIR}"/${PN}-4.0.0-cmake.patch
		  "${FILESDIR}"/${PN}-4.0.0-setup.py-cmake.patch
		  "${FILESDIR}"/${PN}-4.0.0-locate-commands.patch
		  "${FILESDIR}"/${PN}-4.0.0-output-currentISA.patch )

S="${WORKDIR}/${PN}-rocm-${PV}"
CMAKE_USE_DIR="${WORKDIR}/Source"

src_prepare() {
	distutils-r1_src_prepare

	mv ${PN}/Source "${WORKDIR}"/ || die
	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i "${WORKDIR}"/Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i "${WORKDIR}"/Source/CMakeLists.txt || die

	mv ${PN}/cmake "${T}"/ || die

	sed -e "/HipClangVersion/s/0,0,0/$(ver_rs 1-3 ,)/" \
		-e "/SourcePath/s,os\.path\.join.*$,\"${EPREFIX}/usr/share/${PN}\"," \
		-i ${PN}/Common.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile\", end='')|" \
		-i ${PN}/__init__.py || die
}

src_install() {
	distutils-r1_src_install

	insinto /usr/$(get_libdir)/cmake/${PN}
	doins "${T}"/cmake/*.cmake

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}"/Source/*
	dosym . /usr/share/${PN}/Source
}
