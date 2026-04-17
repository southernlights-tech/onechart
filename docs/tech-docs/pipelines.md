# Pipelines

This document provides practical tips and tricks to simplify building and managing CI/CD pipelines, with a specific focus on leveraging GitHub Workflows.

## GitHub Workflows

### NixOS Actions for Dependency Management

This section demonstrates how to effectively use NixOS actions to manage project dependencies within a GitHub workflow, ensuring reproducible builds.

If you are new to NixOS, please visit the official website: [nixos.org](https://nixos.org/)

The recommended approach for managing dependencies with NixOS in a workflow is to use a `nix-shell` file. This file should ideally be placed at the root of your repository. If it resides elsewhere, ensure your workflow navigates to its location before executing `nix-shell`.

Below is an example `shell.nix` file that sets up a Python environment, creates a virtual environment, and installs dependencies from `requirements.txt`:

```nix
# shell.nix

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    python313
    python313Packages.virtualenv
    python313Packages.pip
  ];
  shellHook = ''
    python -m venv myenv
    source myenv/bin/activate
    pip install -r requirements.txt
  '';
}
```

Once your `shell.nix` is configured, you can define your GitHub Actions workflow to utilize it. The following example demonstrates a basic workflow that checks out the repository, sets up Nix, and then runs a Python script within the Nix-managed environment using `nix-shell`:

```yaml
# .github/workflows/nix-example.yml
name: NixOS Example Workflow

on:
  workflow_dispatch:

jobs:
  example:
    runs-on: [ubuntu-latest]

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Install Nix
        uses: cachix/install-nix-action@v31
        with:
          install_options: --no-daemon
          nix_path: nixpkgs=channel:nixos-25.05

      - name: Run Script with Nix-shell
        run: nix-shell --pure --run 'python ./my-script.py'
```

### Further Resources

For the latest releases and more information on the GitHub Actions used, refer to:

*   [cachix/install-nix-action releases](https://github.com/cachix/install-nix-action/releases)
*   [workflow/nix-shell-action releases](https://github.com/workflow/nix-shell-action/releases)
