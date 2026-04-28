# OneChart Documentation

This directory contains the documentation for OneChart, built using MkDocs with Material theme.

## Structure

- `src/` - Markdown source files
- `mkdocs.yml` - MkDocs configuration
- `requirements.txt` - Python dependencies
- `index.html`, `kong-plugins.html` - Generated HTML files

## Development

### Prerequisites

- Python 3.7+
- pip

### Local Development

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Start the development server:
   ```bash
   mkdocs serve
   ```

3. Open http://localhost:8000 in your browser

### Building Documentation

To build the static HTML files:

```bash
mkdocs build
```

This generates the HTML files in the current directory, ready for GitHub Pages.

## Using Make Commands

From the project root:

```bash
# Build documentation
make docs

# Start development server
make docs-serve
```

## Editing Content

- Edit `src/index.md` for the main documentation page
- Edit `src/kong-plugins.md` for Kong plugins documentation
- Modify `src/stylesheets/extra.css` for custom styling
- Update `mkdocs.yml` for configuration changes

The documentation will automatically rebuild when you save changes during development.