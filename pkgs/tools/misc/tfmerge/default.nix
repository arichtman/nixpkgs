{ pkgs, lib, buildGoModule, fetchFromGitHub }:
# nix build .#tfmerge --refresh
buildGoModule rec {
  pname = "tfmerge";
  version = "f52e46d03402690329b93689632a48106ef7f4b2";
  # version = "a404375c17de7178bf6acd02b78cb5c3e7221326";
  # TODO: work out if we can use the supplied go.sum file or how to get this
  vendorHash = null;
  # builds are network-isolated, I think
  # proxyVendor = true;

  src = fetchFromGitHub {
    owner = "magodo";
    # owner = "arichtman";
    rev = version;
    repo = "tfmerge";
    sha256 = "sha256-kQVriU7WenbNGXjdyw1VNZldcOuDcT6q02Yx3IpFQJU=";
  };
  ldflags = [ "-mod=mod"];

  nativeBuildInputs = [ pkgs.terraform ];

  meta = with lib; {
    homepage = "https://github.com/magodo/tfmerge";
    changelog = "https://github.com/magodo/tfmerge/commits/main";
    description = "A tool to merge multiple Terrafrom state files into one.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arichtman ];
  };
}
