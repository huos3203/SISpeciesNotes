安装：mpv
git clone https://github.com/mpv-player/mpv.git
cd mpv
./bootstrap.py
./waf configure --enable-static-build --enable-libmpv-shared --disable-libass
./waf build
测试mpv播放视频是否正常：
 mpv/build/mpv test.mp4
测试正常安装mpv:
./waf install

拷贝mpv/build/libmpv.dylib 到项目中

run 当前项目即可正常运行


