{ pkgs, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfmerge";
  version = "f52e46d03402690329b93689632a48106ef7f4b2";
  # TODO: work out if we can use the supplied go.sum file or how to get this
  vendorHash = "sha256-0aa0dnjzv96svwhf2r5jwrks0qcsd20n9c41rbz7j83zjf7hgkbc";

  src = fetchFromGitHub {
    owner = "magodo";
    rev = version;
    repo = "tfmerge";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [ pkgs.terraform ];

  meta = with lib; {
    homepage = "https://github.com/magodo/tfmerge";
    changelog = "https://github.com/magodo/tfmerge/commits/main";
    description = "A tool to merge multiple Terrafrom state files into one.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arichtman ];
  };
}
