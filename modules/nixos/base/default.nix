{ bin, ...}: {
  imports = bin.scanPaths ./.;
}
