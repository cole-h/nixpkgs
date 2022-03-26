{ lib
, fetchpatch
, fetchurl
, openvpn
, autoconf
, automake
}:

openvpn.overrideAttrs (oldAttrs:
  let
    fetchMulvadPatch = { commit, sha256 }: fetchpatch {
      url = "https://github.com/mullvad/openvpn/commit/${commit}.patch";
      inherit sha256;
    };
  in
  rec {
    version = "2.5.3";

    src = fetchurl {
      url = "https://swupdate.openvpn.net/community/releases/openvpn-${version}.tar.gz";
      sha256 = "sha256-dfAETfRJQwVVynuZWit3qyTylG/cNmgwG47cI5hqX34=";
    };

    patches = oldAttrs.patches or [ ] ++ [
      # look at compare to find the relevant commits
      # https://github.com/OpenVPN/openvpn/compare/release/2.5...mullvad:mullvad-patches
      # used openvpn version is the latest tag ending with -mullvad
      # https://github.com/mullvad/openvpn/tags
      (fetchMulvadPatch {
        commit = "41e44158fc71bb6cc8cc6edb6ada3307765a12e8";
        sha256 = "sha256-UoH0V6gTPdEuybFkWxdaB4zomt7rZeEUyXs9hVPbLb4=";
      })
      (fetchMulvadPatch {
        commit = "f51781c601e8c72ae107deaf25bf66f7c193e9cd";
        sha256 = "sha256-+kwG0YElL16T0e+avHlI8gNQdAxneRS6fylv7QXvC1s=";
      })
      (fetchMulvadPatch {
        commit = "c2f810f966f2ffd68564d940b5b8946ea6007d5a";
        sha256 = "sha256-PsKIxYwpLD66YaIpntXJM8OGcObyWBSAJsQ60ojvj30=";
      })
      (fetchMulvadPatch {
        commit = "879d6a3c0288b5443bbe1b94261655c329fc2e0e";
        sha256 = "sha256-pRFY4r+b91/xAKXx6u5GLzouQySXuO5gH0kMGm77a3c=";
      })
      (fetchMulvadPatch {
        commit = "7f71b37a3b25bec0b33a0e29780c222aef869e9d";
        sha256 = "sha256-RF/GvD/ZvhLdt34wDdUT/yxa+IVWx0eY6WRdNWXxXeQ=";
      })
      (fetchMulvadPatch {
        commit = "abd3c6214529d9f4143cc92dd874d8743abea17c";
        sha256 = "sha256-SC2RlpWHUDMAEKap1t60dC4hmalk3vok6xY+/xhC2U0=";
      })
      (fetchMulvadPatch {
        commit = "b45b090c81e7b4f2dc938642af7a1e12f699f5c5";
        sha256 = "sha256-KPTFmbuJhMI+AvaRuu30CPPLQAXiE/VApxlUCqbZFls=";
      })
    ];

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      autoconf
      automake
    ];
  })
