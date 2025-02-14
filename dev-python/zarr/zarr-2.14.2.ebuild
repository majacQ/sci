# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Chunked, compressed, N-dimensional arrays for Python"
HOMEPAGE="https://github.com/zarr-developers/zarr-python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/asciitree[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	>=dev-python/numcodecs-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		dev-python/msgpack[${PYTHON_USEDEP}]
	)
"

# Reported upsream
# https://github.com/zarr-developers/zarr-python/issues/961
EPYTEST_DESELECT=(
	zarr/tests/test_core.py::TestArray::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithPath::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithChunkStore::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithDirectoryStore::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithNestedDirectoryStore::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithDBMStore::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithSQLiteStore::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithNoCompressor::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithBZ2Compressor::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithBloscCompressor::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithLZMACompressor::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithCustomMapping::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayNoCache::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithStoreCache::test_object_arrays_vlen_bytes
	zarr/tests/test_sync.py::TestArray::test_object_arrays_vlen_bytes
	zarr/tests/test_sync.py::TestArrayWithThreadSynchronizer::test_object_arrays_vlen_bytes
	zarr/tests/test_sync.py::TestArrayWithProcessSynchronizer::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithFSStore::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithFSStoreFromFilesystem::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithFSStorePartialRead::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithFSStoreNested::test_object_arrays_vlen_bytes
	zarr/tests/test_core.py::TestArrayWithFSStoreNestedPartialRead::test_object_arrays_vlen_bytes
)

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/numpydoc dev-python/sphinx-issues dev-python/sphinx-rtd-theme
