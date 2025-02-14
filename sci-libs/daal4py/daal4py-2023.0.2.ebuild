# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python API to the oneAPI Data Analytics Library"
HOMEPAGE="https://github.com/intel/scikit-learn-intelex"
SRC_URI="https://github.com/intel/scikit-learn-intelex/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/scikit-learn-intelex-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-build/cmake
	sys-devel/DPC++
	test? (
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		sci-libs/scikit-learn-intelx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"

DEPEND="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/dpctl[${PYTHON_USEDEP}]
	sci-libs/oneDAL
	virtual/mpi
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-2023.0.2-dont-use-entire-include.patch"
)

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"
	export CPLUS_INCLUDE_PATH="${ESYSROOT}/usr/lib/llvm/intel/include:${ESYSROOT}/usr/lib/llvm/intel/include/sycl:${ESYSROOT}/usr/lib/llvm/intel/include/sycl/CL/sycl"
	export MPIROOT="${ESYSROOT}/usr"
	export DALROOT="${ESYSROOT}/usr"
	# Parallel build is broken
	export MAKEOPTS="-j1"

	distutils-r1_python_prepare_all
}

python_test() {
	export PYTHONPATH="${BUILD_DIR}/install/usr/lib/${EPYTHON}/site-packages"
	# We don't use epytest because it overwrites our PYTHONPATH
	pytest -vv || die
}
