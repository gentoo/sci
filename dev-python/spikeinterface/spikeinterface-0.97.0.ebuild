# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A Python-based module for creating flexible and robust spike sorting pipelines."
HOMEPAGE="https://github.com/SpikeInterface/spikeinterface"
SRC_URI="https://github.com/SpikeInterface/spikeinterface/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="extractors full test"

RDEPEND="
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/neo[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/probeinterface-0.2.16[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	extractors? (
		dev-python/pynwb[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	full? (
		dev-python/distinctipy[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		dev-python/zarr[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
	)
"
# Also wants:
# # Extractors:
# 	MEArec
# 	pyedflib
# 	sonpy
# 	dev-python/hdf5storage (in ::science, masked)

distutils_enable_tests pytest

# Test failures reported upstream:
# https://github.com/SpikeInterface/spikeinterface/issues/307
python_test() {
	# Network sandboxing, mostly (?)
	local EPYTEST_DESELECT=(
		spikeinterface/core/tests/test_datasets.py::test_download_dataset
		spikeinterface/sortingcomponents/tests/test_motion_estimation.py::test_motion_functions
		spikeinterface/sortingcomponents/tests/test_motion_estimation.py::test_estimate_motion_rigid
		spikeinterface/sortingcomponents/tests/test_motion_estimation.py::test_estimate_motion_non_rigid
		spikeinterface/comparison/tests/test_multisortingcomparison.py::test_compare_multiple_sorters
		spikeinterface/curation/tests/test_sortingview_curation.py::test_sortingview_curation
		spikeinterface/exporters/tests/test_export_to_phy.py::test_export_to_phy
		spikeinterface/exporters/tests/test_export_to_phy.py::test_export_to_phy_by_sparsity
		spikeinterface/exporters/tests/test_report.py::test_export_report
		spikeinterface/extractors/tests/test_neoextractors.py
		spikeinterface/sorters/tests/test_launcher.py::test_run_sorters_with_dict
		spikeinterface/sorters/tests/test_launcher.py::test_sorter_installation
		spikeinterface/sorters/tests/test_runsorter.py::test_run_sorter_local
		spikeinterface/sorters/tests/test_runsorter.py::test_run_sorter_docker
		spikeinterface/sorters/tests/test_runsorter.py::test_run_sorter_singularity
		spikeinterface/sorters/tests/test_si_based_sorters.py::SpykingCircus2SorterCommonTestSuite
		spikeinterface/sorters/tests/test_si_based_sorters.py::Tridesclous2SorterCommonTestSuite::test_with_class
		spikeinterface/sorters/tests/test_si_based_sorters.py::Tridesclous2SorterCommonTestSuite::test_with_run
		spikeinterface/sortingcomponents/tests/test_clustering.py::test_find_cluster_from_peaks
		spikeinterface/sortingcomponents/tests/test_features_from_peaks.py::test_features_from_peaks
		spikeinterface/sortingcomponents/tests/test_peak_detection.py::test_detect_peaks
		spikeinterface/sortingcomponents/tests/test_peak_localization.py::test_localize_peaks
		spikeinterface/sortingcomponents/tests/test_peak_pipeline.py::test_run_peak_pipeline
		spikeinterface/sortingcomponents/tests/test_peak_selection.py::test_detect_peaks
		spikeinterface/sortingcomponents/tests/test_template_matching.py::test_find_spikes_from_templates
		spikeinterface/widgets/tests/test_widgets.py::TestWidgets
	)
	# Reported upstream:
	# https://github.com/SpikeInterface/spikeinterface/issues/307#issuecomment-1410840998
	EPYTEST_DESELECT+=(
		spikeinterface/sorters/tests/test_launcher.py::test_collect_sorting_outputs
	)
	local EPYTEST_IGNORE=(
		spikeinterface/widgets/_legacy_mpl_widgets/tests/*
	)
	epytest
}
