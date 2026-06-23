# Assets Directory

This directory contains visual assets for the project documentation.

## Screenshots Needed

### 1. report-preview.png
- **Purpose**: HTML test report screenshot for README
- **Recommended Size**: 1200x800px or similar 3:2 ratio
- **How to Create**:
  1. Run the tests locally: `./newman/run-api-tests.sh`
  2. Open the HTML report: `newman/reports/api-test-report.html`
  3. Take a screenshot of the full report view
  4. Save as `assets/report-preview.png`

### 2. Optional Additional Assets
- `postman-collection-view.png` - Screenshot of Postman collection structure
- `ci-pipeline-success.png` - GitHub Actions workflow success view
- `test-execution-cli.png` - Terminal output of Newman test run

## Image Guidelines

- **Format**: PNG or JPG (PNG preferred for screenshots)
- **Quality**: High resolution, clear text
- **Size**: Optimized for web (< 500KB per image)
- **Consistency**: Use consistent styling and cropping

## Usage in Documentation

Images are referenced in README.md and other docs using:

```markdown
![Description](assets/image-name.png)
```

Or with HTML for size control:

```html
<img src="assets/image-name.png" alt="Description" width="800">
```
