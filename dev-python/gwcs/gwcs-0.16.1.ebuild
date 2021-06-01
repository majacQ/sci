# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Generalized World Coordinate System"
HOMEPAGE="https://gwcs.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-python/asdf[${PYTHON_USEDEP}]
	>=dev-python/astropy-4.1[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

# TODO: package stsci-rtd-theme
#distutils_enable_sphinx docs dev-python/sphinx-astropy dev-python/sphinx-automodapi dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_test() {
	# discovers things in docs dir if we do not
	# explicitly set it to run on the tests dir
	pytest -vv gwcs/tests || die " Tests failed with ${EPYTHON}"
}
