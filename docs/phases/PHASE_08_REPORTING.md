# Phase 8 — Reporting Engine

## Capabilities

- Column selection / sorting / grouping (extensible)
- Header / footer / logo / watermark
- Paper size A4/Letter/A3
- Portrait / landscape
- Page numbers + generated-by/date metadata
- PDF generation via `pdf` package (`ReportBuilderService`)
- Excel/CSV exporters (module hooks via `excel` + `csv` packages)
- Print pipeline via `printing`

## Extension Points

```
ReportConfig → ReportBuilderService.buildEmployeeReport
            → ExcelExportService (planned sibling)
            → CsvExportService (planned sibling)
            → PngSnapshotService (planned sibling)
```

## Permission Gates

- `reports.view` — open builder
- `reports.build` — generate
- `reports.print` — print
- `reports.export` — save file
