# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
inherit distutils-r1 pypi

DESCRIPTION="Interoperability with Gmsh for Python"
HOMEPAGE="https://github.com/inducer/gmsh_interop/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/numpy-1.6.0[${PYTHON_USEDEP}]
	dev-python/pytools[${PYTHON_USEDEP}]
	sci-libs/gmsh[blas]
"
BDEPEND="
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest
