{ customLib, ... }: 

{
  imports = customLib.scanPaths ./.;
}
