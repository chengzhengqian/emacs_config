# to install imagmagic, add rsvg lib and set the flag in autoconfigure
export PKG_CONFIG_PATH=/home/chengzhengqian/Application/imagemagick/imagemagic-6.9.11-install/lib/pkgconfig
./configure --prefix=/home/chengzhengqian/Application/emacs/emacs-26.3-lucid-with-image/ --with-x-toolkit=lucid  --with-imagemagick --with-modules
# for game
export PKG_CONFIG_PATH=/home/chengzhengqian/Application_local/imagemagic-6.9.11-install/lib/pkgconfig
./configure --prefix=/home/chengzhengqian/Application_local/emacs-27.1-lucid-with-image/ --with-x-toolkit=lucid  --with-imagemagick --with-modules
# load env

export LD_LIBRARY_PATH=/home/chengzhengqian/Application_local/imagemagic-6.9.11-install/lib

2023.8
# we update imagemagic to 7.1 in game
# in /home/chengzhengqian/Application_local/imagemagick/ImageMagick-7.1.1-15
./configure --prefix=/home/chengzhengqian/Application_local/imagemagick/imagemagick-7.1-install

# check with rsvg, =no. We need to add corresponding library.
sudo apt install librsvg2-dev 
# rerun the ./configure. !! option, I also install libdjvulibre-dev, libwebp-dev
./configure --prefix=/home/chengzhengqian/Application_local/imagemagick/imagemagick-7.1-install --with-rsvg
# I also add --with-webp
./configure --prefix=/home/chengzhengqian/Application_local/imagemagick/imagemagick-7.1-install --with-rsvg --with-djvu
# we can add more, but this should be enough.
# Then run
make

# now, we install emacs,
# see "/home/chengzhengqian/.emacs.d/lisp/info/build-lucid"
wget http://mirrors.tripadvisor.com/gnu/emacs/emacs-29.1.tar.gz
# in /home/chengzhengqian/Application_local/emacs/emacs-29.1
export PKG_CONFIG_PATH=/home/chengzhengqian/Application_local/imagemagick/imagemagick-7.1-install/lib/pkgconfig
#  it is libjansson-dev after some search
./configure --prefix=/home/chengzhengqian/Application/emacs/emacs-29-lucid-image-json-module  --with-x-toolkit=lucid  --with-imagemagick --with-modules --with-json   CFLAGS='-O3'
