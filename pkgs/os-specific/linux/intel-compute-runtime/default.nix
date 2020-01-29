{ stdenv
, fetchFromGitHub
, patchelf
, cmake
, pkgconfig

, intel-gmmlib
, intel-graphics-compiler
, libva
}:

stdenv.mkDerivation rec {
  pname = "intel-compute-runtime";
  version = "19.44.14658";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = version;
    sha256 = "1pl7yhmgzf7r2b8jyxzmwdc7772gd24izy2z2g4n5s205s125k7x";
  };

  # Build script tries to write the ICD to /etc
  patches = [ ./etc-dir.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ intel-gmmlib intel-graphics-compiler libva ];

  cmakeFlags = [
    "-DSKIP_UNIT_TESTS=1"

    "-DIGC_DIR=${intel-graphics-compiler}"
    "-DETC_DIR=${placeholder "out"}/etc"

    # The install script assumes this path is relative to CMAKE_INSTALL_PREFIX
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  postInstall = ''
    # Avoid clash with intel-ocl
    mv $out/etc/OpenCL/vendors/intel.icd $out/etc/OpenCL/vendors/intel-neo.icd
  '';

  postFixup = ''
    patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ intel-gmmlib intel-graphics-compiler libva ]} \
      $out/lib/intel-opencl/libigdrcl.so
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/intel/compute-runtime;
    description = "Intel Graphics Compute Runtime for OpenCL. Replaces Beignet for Gen8 (Broadwell) and beyond.";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ gloaming ];
  };
}
