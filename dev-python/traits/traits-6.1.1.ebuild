# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Explicitly typed attributes for Python"
HOMEPAGE="https://docs.enthought.com/traits/
	https://github.com/enthought/traits
	https://pypi.org/project/traits/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests nose
# ToDo: Fix doc building:
# AttributeError: 'NoDefaultSpecified' object has no attribute '__name__'
#distutils_enable_sphinx docs/source --no-autodoc

python_prepare_all() {
	sed -i -e "s/'-O3'//g" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	${EPYTHON} -m unittest discover || die
}
