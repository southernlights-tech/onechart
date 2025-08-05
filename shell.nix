{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.mkdocs
    python3Packages.mkdocs-material
    python3Packages.pymdown-extensions
    # mkdocs-minify-plugin is not in nixpkgs, so we'll install it via pip in the shell
  ];

  shellHook = ''
    echo "Setting up Python environment for documentation..."
    
    # Create a temporary virtual environment
    if [ ! -d ".venv" ]; then
      python -m venv .venv
    fi
    
    source .venv/bin/activate
    
    # Install mkdocs-minify-plugin which isn't available in nixpkgs
    pip install "mkdocs-minify-plugin>=0.7.0" --quiet
    
    echo "Documentation environment ready!"
    echo "Available commands:"
    echo "  make docs       - Build documentation"
    echo "  make docs-serve - Serve documentation locally"
  '';
}