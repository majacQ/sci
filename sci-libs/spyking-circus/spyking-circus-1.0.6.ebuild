# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Fast spike sorting by template matching"
HOMEPAGE="https://github.com/spyking-circus/spyking-circus/"
SRC_URI="https://github.com/spyking-circus/spyking-circus/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: Fix this
RESTRICT="test"

RDEPEND="
	>=dev-python/blosc-1.8[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.14[${PYTHON_USEDEP}]
	>=dev-python/h5py-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-2.2.4[${PYTHON_USEDEP}]
	>=dev-python/mpi4py-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17.4[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.21[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.6.7[${PYTHON_USEDEP}]
	>=dev-python/statsmodels-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.40.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.3.1[${PYTHON_USEDEP}]
	>=sci-libs/scikit-learn-0.21.3
	|| ( <=sys-cluster/openmpi-3.0.0 >=sys-cluster/mpich-2.0 )
"
DEPEND="${RDEPEND}"

distutils_enable_sphinx docs_sphinx --no-autodoc
distutils_enable_tests --install pytest
