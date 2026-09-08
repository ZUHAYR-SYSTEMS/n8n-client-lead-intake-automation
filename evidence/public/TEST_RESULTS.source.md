# Functional Test Results — Verified Direct Output

Test endpoint: `POST /webhook/client-lead-intake-v1` on local n8n 2.36.9.

| Case | Synthetic input | Verified result | Status |
|---|---|---|---|
| Sales | Alya Hartono / sales | HTTP 200; workflow wrote `workflow_output/sales_lead.xlsx`; workbook row: `qualified`, `sales`, and the Sales routing message | PASS |
| Support | Bima Pratama / support | HTTP 200; workflow wrote `workflow_output/support_lead.xlsx`; workbook row: `received`, `support`, and the Support routing message | PASS |
| Invalid | blank name; invalid email; `other` department | HTTP 400 with the three required validation errors; no invalid spreadsheet output is produced | PASS |

The successful HTTP responses identify the exact XLSX file written by the workflow. All test data is synthetic.
