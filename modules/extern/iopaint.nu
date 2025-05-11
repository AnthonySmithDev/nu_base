
export extern main [
    --help(-h)                # Muestra mensaje de ayuda
    command?: string@"iopaint commands complete"
]

def "iopaint commands complete" [] {
    [
        "install-plugins-packages"
        "download"
        "list"
        "run"
        "start"
        "start-web-config"
    ]
}

export extern "download" [
    --help(-h)                # Muestra mensaje de ayuda
    model?: string@"iopaint download models"
]

def "iopaint download models" [] {
    [
        "runwayml/stable-diffusion-v1-5",
        "runwayml/stable-diffusion-inpainting",
        "stabilityai/stable-diffusion-2-1",
        "stabilityai/stable-diffusion-xl-base-1.0",
        "stabilityai/stable-diffusion-xl-refiner-1.0",
        "CompVis/stable-diffusion-v1-4",
        "prompthero/openjourney",
        "dreamlike-art/dreamlike-photoreal-2.0"
    ]
}

export extern "install-plugins-packages" [
    --help(-h)                # Muestra mensaje de ayuda
]

export extern "list" [
    --help(-h)                # Muestra mensaje de ayuda
]

export extern "run" [
    --model: string@'iopaint model completions'    # Modelo a usar (default: lama)
    --device: string@'iopaint device completions'  # Dispositivo a usar (cpu|cuda|mps)
    --image: path                                # Ruta de imagen o carpeta (requerido)
    --mask: path                                 # Ruta de máscara o carpeta (requerido)
    --output: path                               # Ruta de salida (requerido)
    --config: path                               # Ruta de archivo de configuración
    --concat                                     # Concatenar imágenes original, máscara y resultado
    --no-concat                                  # No concatenar imágenes
    --model-dir: path                            # Directorio de modelos
    --help                                       # Mostrar ayuda
]

export extern "start-web-config" [
    --help(-h)                # Muestra mensaje de ayuda
]

export extern "start" [
    --host: string@"iopaint host completions"                       # Host address [default: 127.0.0.1]
    --port: int                                                     # Port number [default: 8080]
    --inbrowser                                                     # Launch in browser automatically
    --no-inbrowser                                                  # Don't launch in browser
    --model: string@"iopaint model completions"                     # Model to use [default: lama]
    --model-dir: path                                               # Model directory
    --low-mem                                                       # Enable memory saving options
    --no-low-mem                                                    # Disable memory saving options
    --no-half                                                       # Use full precision (fp32)
    --no-no-half                                                    # Use half precision
    --cpu-offload                                                   # Offload to CPU to save VRAM
    --no-cpu-offload                                                # Don't offload to CPU
    --disable-nsfw-checker                                          # Disable NSFW checker
    --no-disable-nsfw-checker                                       # Enable NSFW checker
    --cpu-textencoder                                               # Run text encoder on CPU
    --no-cpu-textencoder                                            # Run text encoder on GPU
    --local-files-only                                              # Use local files only
    --no-local-files-only                                           # Allow downloading files
    --device: string@"iopaint device completions"                   # Device to use [default: cpu]
    --input: path                                                   # Input image or directory
    --mask-dir: path                                                # Mask directory
    --output-dir: path                                              # Output directory
    --quality: int                                                  # Image quality (0-100) [default: 100]
    --enable-interactive-seg                                        # Enable interactive segmentation
    --no-enable-interactive-seg                                     # Disable interactive segmentation
    --interactive-seg-model: string@"iopaint seg-model completions" # Segmentation model
    --interactive-seg-device: string@"iopaint device completions"   # Segmentation device
    --enable-remove-bg                                              # Enable background removal
    --no-enable-remove-bg                                           # Disable background removal
    --remove-bg-device: string@"iopaint device completions"         # BG removal device
    --remove-bg-model: string@"iopaint bg-model completions"        # BG removal model
    --enable-anime-seg                                              # Enable anime segmentation
    --no-enable-anime-seg                                           # Disable anime segmentation
    --enable-realesrgan                                             # Enable RealESRGAN
    --no-enable-realesrgan                                          # Disable RealESRGAN
    --realesrgan-device: string@"iopaint device completions"        # RealESRGAN device
    --realesrgan-model: string@"iopaint realesrgan completions"     # RealESRGAN model
    --enable-gfpgan                                                 # Enable GFPGAN
    --no-enable-gfpgan                                              # Disable GFPGAN
    --gfpgan-device: string@"iopaint device completions"            # GFPGAN device
    --enable-restoreformer                                          # Enable RestoreFormer
    --no-enable-restoreformer                                       # Disable RestoreFormer
    --restoreformer-device: string@"iopaint device completions"     # RestoreFormer device
    --config: path                                                  # Configuration file
    --help                                                          # Show help
]

def "iopaint host completions" [] {
    ["localhost", "0.0.0.0"]
}

def "iopaint model completions" [] {
    [
        "lama", "ldm", "zits", "mat", "fcf", "manga", "cv2", "migan",
        "runwayml/stable-diffusion-inpainting",
        "Uminosachi/realisticVisionV51_v51VAE-inpainting",
        "redstonehero/dreamshaper_8-inpainting",
        "Sanster/anything-4.0-inpainting",
        "diffusers/stable-diffusion-xl-1.0-inpainting-0.1",
        "Fantasy-Studio/Paint-by-Example",
        "RunDiffusion/Juggernaut-XL-v9-inpainting",
        "SG161222/RealVisXL_V5.0",
        "eienmojiki/Anything-XL",
        "Sanster/PowerPaint-V1-stable-diffusion-inpainting",
        "Sanster/AnyText"
    ]
}

def "iopaint device completions" [] {
    ["cpu", "cuda", "mps"]
}

def "iopaint seg-model completions" [] {
    [
        "vit_b", "vit_l", "vit_h", "sam_hq_vit_b", "sam_hq_vit_l", "sam_hq_vit_h",
        "mobile_sam", "sam2_tiny", "sam2_small", "sam2_base", "sam2_large",
        "sam2_1_tiny", "sam2_1_small", "sam2_1_base", "sam2_1_large"
    ]
}

def "iopaint bg-model completions" [] {
    [
        "briaai/RMBG-1.4", "briaai/RMBG-2.0", "u2net", "u2netp", "u2net_human_seg",
        "u2net_cloth_seg", "silueta", "isnet-general-use", "birefnet-general",
        "birefnet-general-lite", "birefnet-portrait", "birefnet-dis", "birefnet-hrsod",
        "birefnet-cod", "birefnet-massive"
    ]
}

def "iopaint realesrgan completions" [] {
    [
        "realesr-general-x4v3", "RealESRGAN_x4plus", "RealESRGAN_x4plus_anime_6B"
    ]
}
