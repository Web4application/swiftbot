new_local_repository(
    name = "macos_opencv",
    build_file = "@//third_party:opencv_macos.BUILD",
    path = "/opt",
)

new_local_repository(
    name = "macos_ffmpeg",
    build_file = "@//third_party:ffmpeg_macos.BUILD",
    path = "/opt",
)

cc_library(
    name = "opencv",
    srcs = glob(
        [
            "local/lib/libopencv_core.dylib",
            "local/lib/libopencv_highgui.dylib",
            "local/lib/libopencv_imgcodecs.dylib",
            "local/lib/libopencv_imgproc.dylib",
            "local/lib/libopencv_video.dylib",
            "local/lib/libopencv_videoio.dylib",
        ],
    ),
    hdrs = glob(["local/include/opencv2/**/*.h*"]),
    includes = ["local/include/"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "libffmpeg",
    srcs = glob(
        [
            "local/lib/libav*.dylib",
        ],
    ),
    hdrs = glob(["local/include/libav*/*.h"]),
    includes = ["local/include/"],
    linkopts = [
        "-lavcodec",
        "-lavformat",
        "-lavutil",
    ],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)
