
export def main [--deps(-d)] {
  if $deps {
    pip3 install torch==2.1.2 torchvision==0.16.2 --index-url https://download.pytorch.org/whl/cu121
    # pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121


    # sudo ubuntu-drivers autoinstall
    # ubuntu-drivers devices
    # 


    pip3 install iopaint
    pip3 install onnxruntime
    pip3 install rembg
    pip3 install gfpgan
    pip3 install realesrgan
    pip3 install realesrgan
  }

  # ^iopaint install-plugins-packages

  let args = [
    --model=Sanster/PowerPaint-V1-stable-diffusion-inpainting
    --device=cuda

    # --enable-interactive-seg
    # --interactive-seg-model=sam2_1_base
    # --interactive-seg-device=cuda

    # --enable-gfpgan
    # --gfpgan-device=cuda

    # --enable-realesrgan
    # --realesrgan-model=RealESRGAN_x4plus
    # --realesrgan-device=cuda

    # --enable-remove-bg
    # --remove-bg-model=briaai/RMBG-1.4
    # --remove-bg-device=cuda

    # --enable-restoreformer
    # --restoreformer-device=cuda

    --host=0.0.0.0
    # --port=8080
  ]
  CUDA_VISIBLE_DEVICES="0,1,2" ^iopaint start ...$args
}
