{ pkgs, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfmerge";
  version = "f52e46d03402690329b93689632a48106ef7f4b2";

  src = fetchFromGitHub {
    owner = "magodo";
    rev = "v${version}";
    repo = "tfmerge";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [ pkgs.terraform ];

  meta = with lib; {
    homepage = "https://github.com/magodo/tfmerge";
    changelog = "https://github.com/magodo/tfmerge/commits/main";
    description = "A tool to merge multiple Terrafrom state files into one.";
    license = licenses.mpl2;
    maintainers = with maintainers; [ arichtman ];
  };
}
