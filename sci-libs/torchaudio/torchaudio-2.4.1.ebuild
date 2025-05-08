# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
ROCM_SKIP_GLOBALS=1
inherit cuda distutils-r1 multiprocessing rocm optfeature

DESCRIPTION="Data manipulation and transformation for audio signal processing"
HOMEPAGE="https://github.com/pytorch/audio"
SRC_URI="https://github.com/pytorch/audio/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/audio-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda rocm ffmpeg openmp +rnnt"
REQUIRED_USE="?? ( cuda rocm )"

DEPEND="
	ffmpeg? ( <media-video/ffmpeg-7:= )
	sci-libs/caffe2[cuda?,rocm?,openmp?]
"
RDEPEND="
	${DEPEND}
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/expecttest[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/typing-extensions[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
			dev-python/soundfile[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

src_compile() {
	export MAX_JOBS="$(makeopts_jobs)" # Let ninja respect MAKEOPTS

	export USE_CUDA=$(usex cuda 1 0)
	export USE_ROCM=$(usex rocm 1 0)
	use rocm && addpredict /dev/kfd
	export USE_OPENMP=$(usex openmp 1 0)
	export USE_FFMPEG=$(usex ffmpeg 1 0)
	export BUILD_SOX=0
	export BUILD_RNNT=$(usex rnnt 1 0)
	use ffmpeg && export FFMPEG_ROOT=${EPREFIX}/usr

	distutils-r1_src_compile
}

EPYTEST_IGNORE=(
	# librosa
	test/torchaudio_unittest/prototype/hifi_gan/hifi_gan_cpu_test.py
	test/torchaudio_unittest/prototype/hifi_gan/hifi_gan_gpu_test.py

	# infinite test?
	test/torchaudio_unittest/backend/dispatcher/ffmpeg/load_test.py
)

python_test() {
	use rocm && check_amdgpu

	epytest -p expecttest
}

pkg_postinst() {
	optfeature "SoundFile I/O backend" dev-python/soundfile
}
