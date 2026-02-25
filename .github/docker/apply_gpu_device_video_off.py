#!/usr/bin/env python3
"""
ENABLE_VIDEO=OFF 时 GPUDevice.cpp 仍编译 video 相关代码，导致编译错误。
本脚本在源码中插入 #if !ENABLE(VIDEO) / #if ENABLE(VIDEO) 等条件编译，使 VIDEO=OFF 时通过编译。
"""
import sys

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "Source/WebCore/Modules/WebGPU/GPUDevice.cpp"
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        content = f.read()
    content = content.replace("\r\n", "\n").replace("\r", "\n")

    # 1) externalTextureForDescriptor: 在函数体开头插入提前 return，并用 #else 包裹原逻辑，结尾加 #endif
    marker_start = "GPUExternalTexture* GPUDevice::externalTextureForDescriptor(const GPUExternalTextureDescriptor& descriptor)\n{"
    if marker_start not in content:
        sys.stderr.write("apply_gpu_device_video_off: marker_start not found\n")
        sys.exit(1)
    early_return = """#if !ENABLE(VIDEO)
    return nullptr;
#else
"""
    content = content.replace(
        marker_start,
        marker_start + "\n" + early_return,
        1,
    )
    # 在 externalTextureForDescriptor 的最后一个 "return nullptr;" 与 "}" 之间加 #endif，并在 class 前加 #if ENABLE(VIDEO)
    replacement = """ return nullptr;
#endif
}

#if ENABLE(VIDEO)
class GPUDeviceVideoFrameRequestCallback final"""
    for old_end in (
        " return nullptr;\n }\n\nclass GPUDeviceVideoFrameRequestCallback final",
        " return nullptr;\n}\n\nclass GPUDeviceVideoFrameRequestCallback final",
    ):
        if old_end in content:
            content = content.replace(old_end, replacement, 1)
            break
    else:
        sys.stderr.write("apply_gpu_device_video_off: could not find place to add #endif (pattern: return nullptr; } class GPUDeviceVideoFrameRequestCallback)\n")
        sys.exit(1)

    # 2) 在 class GPUDeviceVideoFrameRequestCallback 的 }; 后、importExternalTexture 前加 #endif
    marker_end = """};

 Ref<GPUExternalTexture> GPUDevice::importExternalTexture(const GPUExternalTextureDescriptor& externalTextureDescriptor)"""
    if marker_end not in content:
        sys.stderr.write("apply_gpu_device_video_off: marker_end not found (class }; before importExternalTexture)\n")
        sys.exit(1)
    content = content.replace(
        marker_end,
        """};
#endif

 Ref<GPUExternalTexture> GPUDevice::importExternalTexture(const GPUExternalTextureDescriptor& externalTextureDescriptor)""",
        1,
    )

    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    print("apply_gpu_device_video_off: applied to", path)

if __name__ == "__main__":
    main()
