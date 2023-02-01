# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Image-processing software for cryo-electron microscopy"
HOMEPAGE="https://www3.mrc-lmb.cam.ac.uk/relion/index.php/Main_Page"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/3dem/relion.git"
	[[ ${PV} = 9999 ]] && EGIT_BRANCH="master" || EGIT_BRANCH="ver${PV:0:4}"
	inherit git-r3
	SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/dari/class_ranker_0.1.3_torch_1.0.1.pt.tar.gz"
else
	SRC_URI="
	https://github.com/3dem/relion/archive/${PV}.tar.gz -> ${P}.tar.gz
	ftp://ftp.mrc-lmb.cam.ac.uk/pub/dari/class_ranker_0.1.3_torch_1.0.1.pt.tar.gz
	"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+gui cuda"

DEPEND="
	gui? ( x11-libs/fltk )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	dev-cpp/tbb
	sci-libs/fftw:3.0
	media-libs/tiff
	virtual/mpi
"
RDEPEND="
	${DEPEND}
	sci-chemistry/ctffind
"
BDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	default
}

src_prepare() {
	cmake_src_prepare
	mkdir -p "${S}/external/torch_models/"
	cp "${DISTDIR}/class_ranker_0.1.3_torch_1.0.1.pt.tar.gz" "${S}/external/torch_models/"
	mkdir -p "${S}/external/torch_models/class_ranker/"
	cp "${WORKDIR}/class_ranker_0.1.3_torch_1.0.1.pt" "${S}/external/torch_models/class_ranker/"
	sed -e "s:{CMAKE_INSTALL_PREFIX}/lib:{CMAKE_INSTALL_PREFIX}/$(get_libdir):g" -i CMakeLists.txt || die
	sed -e "s:LIBRARY DESTINATION lib:LIBRARY DESTINATION $(get_libdir):g" -i src/apps/CMakeLists.txt || die
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DALTCPU=$(usex !cuda)
		-DFORCE_OWN_FFTW=OFF
		-DFORCE_OWN_FLTK=OFF
		-DFORCE_OWN_TBB=OFF
		-DCUDA=$(usex cuda)
		-DGUI=$(usex gui)
	)
	cmake_src_configure
}
