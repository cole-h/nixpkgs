{
  stdenvNoCC,
  kmod,
  modules,
  buildEnv,
  name ? "kernel-modules",
}:

buildEnv {
  inherit name;

  paths = modules;

  postBuild = ''
    source ${stdenvNoCC}/setup

    if ! test -d "$out/lib/modules"; then
      echo "No modules found."
      # To support a kernel without modules
      exit 0
    fi

    kernelVersion=$(cd $out/lib/modules && ls -d *)
    if test "$(echo $kernelVersion | wc -w)" != 1; then
       echo "inconsistent kernel versions: $kernelVersion"
       exit 1
    fi

    echo "kernel version is $kernelVersion"

    shopt -s extglob

    # Check if the place where we'd write the depmod map files is a
    # subset of the current store path -- we want to prevent writing
    # to (or trying to) other store paths, because this is most likely
    # undesired and otherwise not allowed by the Nix sandbox.
    modulesPath="$(realpath "$out/lib/modules/$kernelVersion")"
    case "$modulesPath" in
        "$out"/*)
            # Regenerate the depmod map files.  Be sure to pass an explicit
            # kernel version number, otherwise depmod will use `uname -r'.
            echo "regenerating depmod map files"
            rm -f $out/lib/modules/$kernelVersion/modules.!(builtin*|order*)
            ${kmod}/bin/depmod -b $out -C $out/etc/depmod.d -a $kernelVersion
            ;;
        *)
            echo "not regenerating depmod map files, modules are in another store path"
            ;;
    esac
  '';
}
