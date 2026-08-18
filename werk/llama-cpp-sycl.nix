final: prev:
let
  inherit (prev.lib) cmakeBool cmakeFeature makeLibraryPath;

  kit = final.intel-oneapi-toolkit;

  oneapiCCUnwrapped = kit.stdenv.cc.cc.overrideAttrs (old: {
    passthru = (old.passthru or { }) // {
      langCC = true;
    };
  });

  oneapiCC = final.wrapCCWith {
    cc = oneapiCCUnwrapped;
    gccForLibs = final.gcc.cc;
    extraPackages = [ kit ];
    extraBuildCommands = ''
      ln -s $out/bin/clang++ $out/bin/icpx
      ln -s $out/bin/clang   $out/bin/icx

      echo "export CXX=\"$out/bin/icpx\"" >> $out/nix-support/setup-hook
      echo "export CC=\"$out/bin/icx\"" >> $out/nix-support/setup-hook

      echo "export ONEAPI_ROOT=\"${kit}\"" >> $out/nix-support/setup-hook
    '';
  };

  oneapiStdenv = final.overrideCC final.stdenv oneapiCC;

  icrDriversFixed =
    final.runCommand "intel-compute-runtime-drivers-igc-rpath"
      { nativeBuildInputs = [ final.patchelf ]; }
      ''
        mkdir -p $out/lib
        cp -a ${final.intel-compute-runtime.drivers}/lib/. $out/lib/
        chmod -R +w $out/lib
        find $out/lib -type f -name "*.so*" -exec \
          patchelf --add-rpath ${final.intel-graphics-compiler}/lib {} \;
      '';
in
{
  llama-cpp-sycl =
    (prev.llama-cpp.override {
      stdenv = oneapiStdenv;
      blasSupport = false;
      cpuArchDynamicDispatch = false;
    }).overrideAttrs
      (old: {
        pname = "llama-cpp-sycl";

        hardeningDisable = (old.hardeningDisable or [ ]) ++ [
          "fortify"
          "fortify3"
        ];

        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          final.makeWrapper
        ];

        buildInputs = (old.buildInputs or [ ]) ++ [
          kit
          final.level-zero
        ];

        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          (cmakeBool "GGML_SYCL" true)
          (cmakeFeature "GGML_SYCL_TARGET" "INTEL")
          (cmakeFeature "CMAKE_PREFIX_PATH" "${kit}/compiler/latest;${kit}/mkl/latest;${kit}/dnnl/latest")
          (cmakeBool "GGML_SYCL_F16" true)
          (cmakeBool "GGML_SYCL_DNN" true)
          (cmakeBool "GGML_SYCL_SUPPORT_LEVEL_ZERO_API" true)
          (cmakeFeature "LEVEL_ZERO_INCLUDE_DIR" "${final.level-zero}/include")
          (cmakeFeature "ZE_LOADER_LIB" "${final.level-zero}/lib/libze_loader.so")
        ];

        env = (old.env or { }) // {
          MKLROOT = "${kit}/mkl/latest";
        };

        postInstall = builtins.replaceStrings [
          "installShellCompletion --cmd llama-server --bash <($out/bin/llama-server --completion-bash)"
        ] [ ": # shell completion skipped: SYCL llama-server aborts without a GPU" ] (old.postInstall or "");

        postFixup = (old.postFixup or "") + ''
          for f in $out/bin/*; do
            [ -L "$f" ] && continue
            [ -f "$f" ] && [ -x "$f" ] || continue
            wrapProgram "$f" --prefix LD_LIBRARY_PATH : \
              ${makeLibraryPath [ icrDriversFixed final.level-zero ]}
          done
        '';
      });

  llama-cpp-sycl-dnn-only = final.llama-cpp-sycl.overrideAttrs (old: {
    pname = "llama-cpp-sycl-dnn-only";
    cmakeFlags = old.cmakeFlags ++ [ (cmakeBool "GGML_SYCL_F16" false) ];
  });

  llama-cpp-sycl-f16-only = final.llama-cpp-sycl.overrideAttrs (old: {
    pname = "llama-cpp-sycl-f16-only";
    cmakeFlags = old.cmakeFlags ++ [ (cmakeBool "GGML_SYCL_DNN" false) ];
  });
}
