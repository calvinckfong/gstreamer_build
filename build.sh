#!/bin/bash

ROOT=${HOME}
LIB=${ROOT}/lib64
BIN=${ROOT}/bin
INC=${ROOT}/include

# Packages required by core
# makeinfo (could be obtained from texinfo)
# gtk-doc

# Packages required by plugins
# libtool

# Packages required by webrtc and srt
# srt-devel, libnice-devel, meson(python3)

VERSION=1.16
PATH="$PATH:${HOME}/bin"
PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${HOME}/lib/pkgconfig:${HOME}/lib64/pkgconfig"
WORKING=$(pwd)


BuildLibsrtp2()
{
	SRC=libsrtp2
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	# require v2.1 or above
	git clone --branch v2.3 https://github.com/cisco/libsrtp.git $SRC
	echo "[$SRC] configure..."
	./configure --prefix=${ROOT} > $LOG 2>&1
	echo "[$SRC] make..."
	make -j >> $LOG 2>&1
	echo "[$SRC] install..."
	make install >> $LOG 2>&1
}


BuildLibnice()
{
	SRC=libnice
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	# require 0.1.15 or above
	git clone --branch 0.1.17 https://gitlab.freedesktop.org/libnice/libnice.git $SRC
	cd $SRC
	meson build --prefix=$HOME
	ninja -C build 
	ninja -C build install
}


BuildGStreamer()
{
	SRC=gstreamer_core
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	git clone --branch ${VERSION} https://gitlab.freedesktop.org/gstreamer/gstreamer.git $SRC

	cd $SRC
	echo "[$SRC] libtoolize..."
	libtoolize > $LOG 2>&1
	echo "[$SRC] autogen.sh..."
	./autogen.sh >> $LOG 2>&1
	echo "[$SRC] configure..."
	./configure --prefix=${ROOT} >> $LOG 2>&1
	echo "[$SRC] make..."
	make -j >> $LOG 2>&1
	echo "[$SRC] install..."
	make install >> $LOG 2>&1
}

BuildPluginsBase()
{
	SRC=gst-plugins-base
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	git clone --branch ${VERSION} https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git $SRC

	cd $SRC
	echo "[$SRC] libtoolize..."
	libtoolize > $LOG 2>&1
	echo "[$SRC] autogen.sh..."
	./autogen.sh >> $LOG 2>&1
	echo "[$SRC] configure..."
	./configure --prefix=${ROOT} >> $LOG 2>&1
	echo "[$SRC] make..."
	make -j >> $LOG 2>&1
	echo "[$SRC] install..."
	make install >> $LOG 2>&1
}

BuildPluginsGood()
{
	SRC=gst-plugins-good
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	git clone --branch ${VERSION} https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git $SRC

	cd $SRC
	echo "[$SRC] libtoolize..."
	libtoolize > $LOG 2>&1
	echo "[$SRC] autogen.sh..."
	./autogen.sh >> $LOG 2>&1
	echo "[$SRC] configure..."
	./configure --prefix=${ROOT} >> $LOG 2>&1
	echo "[$SRC] make..."
	make -j >> $LOG 2>&1
	echo "[$SRC] install..."
	make install >> $LOG 2>&1
}

BuildPluginsUgly()
{
	SRC=gst-plugins-ugly
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	git clone --branch ${VERSION} https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git $SRC

	cd $SRC
	echo "[$SRC] libtoolize..."
	libtoolize > $LOG 2>&1
	echo "[$SRC] autogen.sh..."
	./autogen.sh >> $LOG 2>&1
	echo "[$SRC] configure..."
	./configure --prefix=${ROOT} >> $LOG 2>&1
	echo "[$SRC] make..."
	make -j >> $LOG 2>&1
	echo "[$SRC] install..."
	make install >> $LOG 2>&1
}

BuildPluginsBad()
{
	SRC=gst-plugins-bad
	LOG=${SRC}_build.log

	echo "==================================="
	echo "    Build ${SRC}"
	echo "==================================="

	echo "Git source to $SRC"
	git clone --branch ${VERSION} https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git $SRC

	cd $SRC
	echo "[$SRC] libtoolize..."
	libtoolize > $LOG 2>&1
	echo "[$SRC] autogen.sh..."
	./autogen.sh >> $LOG 2>&1
	echo "[$SRC] configure..."
	./configure --prefix=${ROOT} >> $LOG 2>&1
	echo "[$SRC] make..."
	make -j > $LOG 2>&1
	echo "[$SRC] install..."
	make install >> $LOG 2>&1
}

cd $WORKING; BuildLibsrtp2	# required by SRT in plugins-bad
cd $WORKING; BuildLibnice # required by WebRTC in plugins-bad
cd $WORKING; BuildGStreamer
cd $WORKING; BuildPluginsBase
cd $WORKING; BuildPluginsGood
cd $WORKING; BuildPluginsUgly
cd $WORKING; BuildPluginsBad

