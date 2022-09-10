{
  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      dynamicPkgs = nixpkgs.legacyPackages.${system};
      pkgs = dynamicPkgs.pkgsStatic;
      genPackages = pkgs: rec {
        hellofastcgi = pkgs.buildGoModule {
          name = "hellofastcgi";
          src = ./.;
          vendorHash = null;
          ldflags = [ "-linkmode=external" ];
        };

        production = pkgs.runCommand "hellofastcgi" { inherit hellofastcgi; htaccess = ./.htaccess; } ''
          mkdir -p $out
          cp $hellofastcgi/bin/fastcgi $out/hellofastcgi.fcgi
          cp $htaccess $out/.htaccess
        '';

        debug = pkgs.runCommand "hellofastcgi" { inherit hellofastcgi; htaccess = ./.htaccess.debug; } ''
          mkdir -p $out
          cp $hellofastcgi/bin/cgi $out/hellofastcgi.cgi
          cp $htaccess $out/.htaccess
        '';

        default = hellofastcgi;
      };
      dynamicPackages = genPackages dynamicPkgs;
    in
    rec {
      packages = genPackages pkgs;

      apps.deploy = flake-utils.lib.mkApp {
        drv = dynamicPkgs.writeShellScriptBin "deploy" ''
          set -euxo pipefail
          export PATH="${nixpkgs.lib.makeBinPath [ dynamicPkgs.rsync dynamicPkgs.openssh ]}"
          rsync -vrPL --delete ${self.packages.x86_64-linux.production}/ dh_ptskzf@hellofastcgi.piperswe.me:hellofastcgi.piperswe.me
        '';
      };

      apps.deploy-debug = flake-utils.lib.mkApp {
        drv = dynamicPkgs.writeShellScriptBin "deploy-debug" ''
          set -euxo pipefail
          export PATH="${nixpkgs.lib.makeBinPath [ dynamicPkgs.rsync dynamicPkgs.openssh ]}"
          rsync -vrPL --delete ${self.packages.x86_64-linux.debug}/ dh_ptskzf@hellofastcgi.piperswe.me:hellofastcgi.piperswe.me
        '';
      };

      apps.ssh = flake-utils.lib.mkApp {
        drv = dynamicPkgs.writeShellScriptBin "ssh" ''
          set -euxo pipefail
          export PATH="${nixpkgs.lib.makeBinPath [ dynamicPkgs.openssh ]}"
          exec ssh dh_ptskzf@hellofastcgi.piperswe.me
        '';
      };

      apps.dev = flake-utils.lib.mkApp {
        drv = dynamicPackages.hellofastcgi;
        exePath = "/bin/dev";
      };

      apps.go = flake-utils.lib.mkApp {
        drv = dynamicPackages.hellofastcgi.go;
      };

      apps.dev-fast = flake-utils.lib.mkApp {
        drv = dynamicPkgs.writeShellScriptBin "dev-fast" ''
          set -euxo pipefail
          export PATH="${nixpkgs.lib.makeBinPath [ dynamicPackages.hellofastcgi.go ]}"
          exec go run ./cmd/dev
        '';
      };

      apps.default = apps.dev;
    });
}
