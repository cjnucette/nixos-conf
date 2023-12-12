args:
  builtins.map
    (fileName: (import (./. + "/${fileName}") args)) # -> function to be applіed to the list
    (builtins.filter
      (fileName: fileName != "default.nix") # -> return list with this file filter out.
      (builtins.attrNames (builtins.readDir ./.))) # -> return list of filenames in the current directory
