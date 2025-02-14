# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Distances and representations of persistence diagrams"
HOMEPAGE="https://persim.scikit-tda.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/hopcroftkarp[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/deprecated[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Reported upsream:
	# https://github.com/scikit-tda/persim/issues/66
	test/test_landscapes.py::TestPersLandscapeExact::test_exact_critical_pairs
	test/test_persim.py::test_integer_diagrams
	test/test_persim.py::TestEmpty::test_empyt_diagram_list
	test/test_persim.py::TestTransforms::test_lists_of_lists
	test/test_persim.py::TestTransforms::test_n_pixels
	test/test_persim.py::TestTransforms::test_multiple_diagrams
	test/test_persistence_imager.py::test_empty_diagram_list
	test/test_persistence_imager.py::test_fit_diagram
	test/test_persistence_imager.py::test_fit_diagram_list
	test/test_persistence_imager.py::test_mixed_pairs
	test/test_persistence_imager.py::TestTransformOutput::test_lists_of_lists
	test/test_persistence_imager.py::TestTransformOutput::test_n_pixels
	test/test_persistence_imager.py::TestTransformOutput::test_multiple_diagrams
)
