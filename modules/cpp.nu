
export def run [...input: string] {
  default $input
  run-external ./main
  rm ./main
}

export def wrun [...input: string] {
  watch . --glob=**/*.cpp {||
    clear
    default $input
    run-external ./main
    rm ./main
  }
}

export def build [...input: string] {
  g++ -o main $input
}

export def debug [...input: string] {
  g++ -ggdb -o main $input
}

export def release [...input: string] {
  g++ -02 -DNDEBUG $input -o main
}

# Disabling compiler extensions
export def disabling [...input: string] {
  g++ -pedantic-errors $input -o main
}

# Increasing your warning levels
export def warning [...input: string] {
  g++ -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion $input -o main
}

# Treat warnings as errors
export def werror [...input: string] {
  g++ -Werror $input -o main
}

# Setting a language standard
export def standard [...input: string] {
  g++ -std=c++20 $input -o main
}

export def include [...input: string] {
  g++ -I/source/includes -o main
  # There is no space after the -I.
}

export def default [input: list<string>] {
  let args = [
    "-pedantic-errors"
    "-Wall"
    "-Weffc++"
    "-Wextra"
    "-Wconversion"
    "-Wsign-conversion"
    "-Werror"
    "-std=c++20"
  ]
  g++ $args $input -o main
}

export def clangd [] {
  'CompileFlags:
    Add: [-std=c++20]' | save .clangd
}

export def float [cmd: string] {
  if not ($env.ZELLIJ? | is-empty) {
    zellij run -f -- $cmd
  } else {
    ^$cmd
  }
}
