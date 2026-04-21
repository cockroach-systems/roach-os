{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    swaks
    thunderbird
    mutt
  ];
}