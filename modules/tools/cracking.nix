{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    thc-hydra
    john # john-the-ripper
    hashcat
    hashid
    pocl # CPU-based OpenCL for hashcat in VMs
  ];

  # OpenCL ICD loader
  hardware.graphics.extraPackages = with pkgs; [
    pocl
  ];
}