
export extern main [
  --pass-exit-codes                 # Exit with highest error code from a phase.
  --help                            # Display this information.
  --target-help                     # Display target specific command line options (including assembler and linker options).
  --help: string                    #{common|optimizers|params|target|warnings|[^]{joined|separate|undocumented}}[,...].
                                    # Display specific types of command line options.
                                    # (Use '-v --help' to display command line options of sub-processes).
  --version                         # Display compiler version information.
  --dumpspecs                       # Display all of the built in spec strings.
  --dumpversion                     # Display the version of the compiler.
  --dumpmachine                     # Display the compiler's target processor.
  --foffload: string                # Specify offloading targets.
  --print-search-dirs               # Display the directories in the compiler's search path.
  --print-libgcc-file-name          # Display the name of the compiler's companion library.
  --print-file-name: string         # Display the full path to library <lib>.
  --print-prog-name: string         # Display the full path to compiler component <prog>.
  --print-multiarch                 # Display the target's normalized GNU triplet, used as
                                    # a component in the library path.
  --print-multi-directory           # Display the root directory for versions of libgcc.
  --print-multi-lib                 # Display the mapping between command line options and
                                    # multiple library search directories.
  --print-multi-os-directory        #  Display the relative path to OS libraries.
  --print-sysroot                   # Display the target libraries directory.
  --print-sysroot-headers-suffix    # Display the sysroot suffix used to find headers.
  # --Wa: string                    # Pass comma-separated <options> on to the assembler.
  # --Wp: string                    # Pass comma-separated <options> on to the preprocessor.
  # --Wl: string                    # Pass comma-separated <options> on to the linker.
  --Xassembler: string              # Pass <arg> on to the assembler.
  --Xpreprocessor: string           # Pass <arg> on to the preprocessor.
  --Xlinker: string                 # Pass <arg> on to the linker.
  --save-temps                      # Do not delete intermediate files.
  --save-temps: string              # Do not delete intermediate files.
  --no-canonical-prefixes           # Do not canonicalize paths when building relative
                                    # prefixes to other gcc components.
  --pipe                            # Use pipes rather than intermediate files.
  --time                            # Time the execution of each subprocess.
  --specs: string                   # Override built-in specs with the contents of <file>.
  --std: string                     # Assume that the input sources are for <standard>.
  --sysroot: string                 # Use <directory> as the root directory for headers
                                    # and libraries.
  -B: string                        # Add <directory> to the compiler's search paths.
  -v                                # Display the programs invoked by the compiler.
  -E                                # Preprocess only; do not compile, assemble or link.
  -S                                # Compile only; do not assemble or link.
  -c                                # Compile and assemble, but do not link.
  -o: string                        # Place the output into <file>.
  --pie                             # Create a dynamically linked position independent
                                    # executable.
  --shared                          # Create a shared library.
  -x: string                        # Specify the language of the following input files.
                                    # Permissible languages include: c c++ assembler none
                                    # 'none' means revert to the default behavior of
                                    # guessing the language based on the file's extension.
]
