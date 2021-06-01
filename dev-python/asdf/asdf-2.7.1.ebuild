# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python library for the Advanced Scientific Data Format"
HOMEPAGE="https://asdf.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/astropy[${PYTHON_USEDEP}]
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/gwcs[${PYTHON_USEDEP}]
	)
	doc? ( media-gfx/graphviz )
"

RDEPEND="
	>=dev-python/jsonschema-3.0.2[${PYTHON_USEDEP}]
	<dev-python/jsonschema-4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.10[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/semantic_version-2.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/astropy dev-python/sphinx-astropy dev-python/matplotlib dev-python/docutils

python_test() {
	# discovers things in docs dir if we do not
	# explicitly set it to run on the tests dir
	pytest -vv asdf/tests || die " Tests failed with ${EPYTHON}"
}
