{ bin, ...}: 

{
  imports = bin.scanPaths ./.;
}
