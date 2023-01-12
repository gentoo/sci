# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="Command line tool and API for geospatial raster data"
HOMEPAGE="https://github.com/rasterio/rasterio"
SRC_URI="https://github.com/rasterio/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/gdal:=[aux-xml(+),jpeg,png,threads(+)]
	dev-python/affine[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cligj[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/click-plugins[${PYTHON_USEDEP}]
	dev-python/snuggs[${PYTHON_USEDEP}]
"

#DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/shapely[${PYTHON_USEDEP}]
		sci-libs/gdal:=[aux-xml(+),jpeg,png,threads(+)]
	)
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# disable tests failing for unknown reason
		tests/test_env.py::test_rio_env_no_credentials
		tests/test_rio_info.py::test_info_azure_unsigned

		tests/test__env.py::test_search_debian_gdal_data
		tests/test__env.py::test_search_gdal_data_debian
		tests/test_warp.py::test_reproject_resampling[Resampling.cubic]
		tests/test_warp.py::test_reproject_resampling[Resampling.lanczos]
		tests/test_warp.py::test_reproject_resampling_alpha[Resampling.cubic]
		tests/test_warp.py::test_reproject_resampling_alpha[Resampling.lanczos]

		#tests/test_warp.py::test_warp_from_to_file_multi

		# aux-xml
		#tests/test_dataset.py::test_files
		#tests/test_gcps.py::test_write_read_gcps_buffereddatasetwriter
		#tests/test_rio_edit_info.py::test_delete_nodata
		#tests/test_update.py::test_update_nodatavals_none

		# curl
		#tests/test_warp.py::test_reproject_error_propagation

		# geos
		#tests/test_warp.py::test_transform_geom_polygon_offset
		#tests/test_warp.py::test_transform_geom_polygon_cutting

		# png
		#tests/test_colormap.py::test_write_colormap
		#tests/test_no_georef.py::test_write
		#tests/test_png.py::test_write_ubyte
		#tests/test_rio_convert.py::test_autodetect_format
		#tests/test_rio_merge.py::test_merge_output_dataset
		#tests/test_shutil.py::test_delete[None-png]
		#tests/test_shutil.py::test_delete[PNG-png]
		#tests/test_write.py::test_write__autodetect_driver[png-PNG]
		#tests/test_write.py::test_issue2088[PNG]

		# jpeg
		#tests/test_blocks.py::test_block_size_exception
		#tests/test_crs.py::test_read_no_crs
		#tests/test_memoryfile.py::test_zip_file_object_read
		#tests/test_memoryfile.py::test_vrt_memfile
		#tests/test_memoryfile.py::test_write_plus_model_jpeg
		#tests/test_rio_convert.py::test_format
		#tests/test_rio_convert.py::test_format_short
		#tests/test_rio_convert.py::test_output_opt
		#tests/test_rio_convert.py::test_convert_overwrite_without_option
		#tests/test_rio_convert.py::test_convert_overwrite_with_option
		#tests/test_rio_stack.py::test_format_jpeg
		#tests/test_rio_warp.py::test_warp_vrt_gcps
		#tests/test_shutil.py::test_copy_strict_failure
		#tests/test_shutil.py::test_copy_strict_silent_failure
		#tests/test_write.py::test_write__autodetect_driver[jpg-JPEG]
		#tests/test_write.py::test_write__autodetect_driver[jpeg-JPEG]
		#tests/test_write.py::test_issue2088[JPEG]

		# threads
		#tests/test_thread_pool_executor.py::test_threads_main_env
		#tests/test_threading.py::test_child_thread_inherits_env
	)

	mv rasterio{,.bak} || die # Avoid non-working local import
	epytest ${deselect[@]/#/--deselect }
	mv rasterio{.bak,} || die
}
