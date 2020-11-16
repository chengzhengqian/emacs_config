# to install imagmagic, add rsvg lib and set the flag in autoconfigure
export PKG_CONFIG_PATH=/home/chengzhengqian/Application/imagemagick/imagemagic-6.9.11-install/lib/pkgconfig
./configure --prefix=/home/chengzhengqian/Application/emacs/emacs-26.3-lucid-with-image/ --with-x-toolkit=lucid  --with-imagemagick --with-modules
# for game
export PKG_CONFIG_PATH=/home/chengzhengqian/Application_local/imagemagic-6.9.11-install/lib/pkgconfig
./configure --prefix=/home/chengzhengqian/Application_local/emacs-27.1-lucid-with-image/ --with-x-toolkit=lucid  --with-imagemagick --with-modules
# load env

export LD_LIBRARY_PATH=/home/chengzhengqian/Application_local/imagemagic-6.9.11-install/lib
