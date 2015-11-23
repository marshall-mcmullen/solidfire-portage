# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: 
#
inherit flag-o-matic

export GCC_VERSION="4.8.1"
DEPEND="=sys-devel/gcc-solidfire-${GCC_VERSION}"
export GCC="gcc-solidfire-${GCC_VERSION}"
export CXX="g++-solidfire-${GCC_VERSION}"
append-cxxflags "-std=c++11"
