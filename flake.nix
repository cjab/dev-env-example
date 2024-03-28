{
  description = "A multi-devEnv example flake.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    # devEnvs will build for only x86_64-linux.
    # I don't think we care about any other architectures.
    system = "x86_64-linux";
    # Import nixpkgs for x86_64-linux
    pkgs = import nixpkgs { inherit system; };
  in {

    # We can define multiple development environments here.
    devShells.${system} = rec {
      # The default env is used by commands like `dev develop` when
      # no env is explicitly requested
      default = env1;

      env1 = pkgs.mkShell {
        # Packages to be built and made available in this environment
        buildInputs = [
          # Python 3.9 in this case
          pkgs.python39
        ];

        # Any env vars for this environment can be setup here.
        CURRENT_ENV = "env1";

        shellHook = ''
          # And the hook that runs when the environment is run here
          blue=$(tput bold)$(tput setaf 4)
          reset=$(tput sgr0)
          echo ""
          echo "$blue Welcome to $CURRENT_ENV $reset"
          echo ""
          python --version
          echo ""
        '';
      };

      env2 = pkgs.mkShell {
        # Packages to be built and made available in this environment
        buildInputs = [
          # Python 3.13 in this case
          pkgs.python313
        ];

        # Any env vars for this environment can be setup here.
        CURRENT_ENV = "env2";

        shellHook = ''
          # And the hook that runs when the environment is run here
          purple=$(tput setaf 5)
          reset=$(tput sgr0)
          echo ""
          echo "$purple Welcome to $CURRENT_ENV $reset"
          echo ""
          python --version
          echo ""
        '';
      };
    };
  };
}
