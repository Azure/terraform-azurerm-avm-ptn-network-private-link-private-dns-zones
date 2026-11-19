# ModTM module repair progress

Updated: 2026-11-19

## Terraform repository-sync runs

- Latest relevant run: [44489320780](https://github.com/Azure/azure-verified-modules-tools/actions/runs/44489320780), failed.
- Failed job: [135453397103](https://github.com/Azure/azure-verified-modules-tools/actions/runs/44489320780/job/135453397103), root TFLint scope.
- Known latest-run snapshot: of the 10 most recent Terraform Sync runs at refresh time, 5 succeeded and 5 failed.
- Fleet sync: [44525899047](https://github.com/Azure/azure-verified-modules-tools/actions/runs/44525899047) finished 228/230 on 2026-11-19; the remaining module failure was this Private DNS obsolete-rule repair.

## Private DNS Zones

- Repository: [Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones](https://github.com/Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones)
- Branch: `jaredfholgate-private-dns-lint-repair`
- Main-state finding: live `main` at `db21171` uses invalid rule `required_output_rmfr7`.
- Correction: replaced it with canonical rule `avm_output_resource_id_required`, preserving the `terraform_naming_convention` exemption.
- Existing PR: [#231](https://github.com/Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones/pull/231) is a Regions dependency update and does not contain this rule change.
- PR state: [#234](https://github.com/Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones/pull/234) is open as a draft with head `602b3f4eca2de8812f44c3f300115257ea33e1f0`. PR check, unit, integration, CodeQL, CLA, and all 9 runnable E2E examples passed. The PR remains mergeable and pending review; no merge was performed.
- Test state: local `avm test unit` passed (1 run); local `avm test` validation passed across 9 examples; two local `avm pre-commit` passes passed and were idempotent.
- Lint state: GitHub PR check passed and exercised the canonical TFLint rule name. Local `avm lint` was blocked by an unrelated shared AVM plugin-cache lock after a Windows filename-too-long download failure.
- Candidate state: commit `265fb3956f25a12ab0de954b15c5cfd3a477fa75` is not present on the live repository and is not reusable.
- Policy: not run.
- E2E: deferred.
- Release: not applicable until a lint-fix PR is qualified and merged.
