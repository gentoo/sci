# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="offline/online spike sorting"
HOMEPAGE="https://github.com/tridesclous/tridesclous"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui test"

RDEPEND="
	<dev-python/numpy-1.24.0[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/hdbscan[${PYTHON_USEDEP}]
	dev-python/loky[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/neo[${PYTHON_USEDEP}]
	dev-python/numba
	dev-python/openpyxl[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/seaborn[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
	gui? (
		dev-python/PyQt5[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# Network sandboxing, this is sadly more than half the test suite :(
EPYTEST_DESELECT=(
	tridesclous/tests/test_cleancluster.py::test_auto_split
	tridesclous/tests/test_cleancluster.py::test_trash_not_aligned
	tridesclous/tests/test_cleancluster.py::test_auto_merge
	tridesclous/tests/test_cleancluster.py::test_trash_low_extremum
	tridesclous/tests/test_cleancluster.py::test_trash_small_cluster
	tridesclous/tests/test_cluster.py::test_sawchaincut
	tridesclous/tests/test_cluster.py::test_pruningshears
	tridesclous/tests/test_decomposition.py::test_all_decomposition
	tridesclous/tests/test_export.py::test_export
	tridesclous/tests/test_export.py::test_export_catalogue_spikes
	tridesclous/tests/test_jobtools.py::test_run_parallel_signalprocessor
	tridesclous/tests/test_matplotlibplot.py::test_plot_probe_geometry
	tridesclous/tests/test_matplotlibplot.py::test_plot_signals
	tridesclous/tests/test_matplotlibplot.py::test_plot_waveforms_with_geometry
	tridesclous/tests/test_matplotlibplot.py::test_plot_waveforms
	tridesclous/tests/test_matplotlibplot.py::test_plot_features_scatter_2d
	tridesclous/tests/test_metrics.py::test_all_metrics
	tridesclous/tests/test_metrics.py::test_cluster_ratio
	tridesclous/tests/test_peeler.py::test_peeler_geometry
	tridesclous/tests/test_peeler.py::test_peeler_geometry_cl
	tridesclous/tests/test_peeler.py::test_peeler_empty_catalogue
	tridesclous/tests/test_peeler.py::test_peeler_several_chunksize
	tridesclous/tests/test_peeler.py::test_peeler_with_and_without_preprocessor
	tridesclous/tests/test_peeler.py::test_export_spikes
	tridesclous/tests/test_report.py::test_summary_catalogue_clusters
	tridesclous/tests/test_report.py::test_summary_noise
	tridesclous/tests/test_report.py::test_summary_after_peeler_clusters
	tridesclous/tests/test_report.py::test_generate_report
	tridesclous/tests/test_autoparams.py::test_get_auto_params
	tridesclous/tests/test_catalogueconstructor.py::test_catalogue_constructor
	tridesclous/tests/test_catalogueconstructor.py::test_make_catalogue
	tridesclous/tests/test_catalogueconstructor.py::test_ratio_amplitude
	tridesclous/tests/test_catalogueconstructor.py::test_create_savepoint_catalogue_constructor
	tridesclous/tests/test_catalogueconstructor.py::test_feature_with_lda_selection
	tridesclous/tests/test_cataloguetools.py::test_apply_all_catalogue_steps
	tridesclous/tests/test_dataio.py::test_DataIO
	tridesclous/tests/test_dataio.py::test_DataIO_probes
	tridesclous/tests/test_datasets.py::test_download_dataset
	tridesclous/tests/test_datasets.py::test_get_dataset
	tridesclous/tests/test_datasource.py::test_RawDataSource
	tridesclous/tests/test_datasource.py::test_NeoRawIOAggregator
	tridesclous/tests/test_peakdetector.py::test_compare_offline_online_engines
	tridesclous/tests/test_peakdetector.py::test_detect_geometrical_peaks
	tridesclous/tests/test_peakdetector.py::test_peak_sign_symetry
	tridesclous/tests/test_signalpreprocessor.py::test_compare_offline_online_engines
	tridesclous/tests/test_signalpreprocessor.py::test_auto_pad_width
	tridesclous/tests/test_tools.py::test_fix_prb_file_py2
)

python_test() {
	local EPYTEST_IGNORE=(
		tridesclous/online/tests/*
	)
	if use !gui ; then
		local EPYTEST_IGNORE+=(
			tridesclous/gui/*
		)
	fi
	epytest
}
