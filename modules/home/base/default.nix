{ bin, ... }:

{
  imports = bin.scanPaths./.;
}
