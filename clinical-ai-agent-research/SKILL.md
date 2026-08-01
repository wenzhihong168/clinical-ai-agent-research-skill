---
name: clinical-ai-agent-research
description: Orchestrate rigorous research on clinical decision support, disease diagnosis or prognosis prediction, multimodal patient data, medical machine learning, RAG, and single- or multi-agent systems. Use for study design, cohort and endpoint definition, leakage-safe validation, model and agent evaluation, literature review, top medical-journal or AI-conference writing, peer-review simulation, and publication-quality figures. Treat cell, omics, pathology, or molecular data as optional nested modalities rather than the default research level.
---

# Clinical AI Agent Research

## Scope

Work at the patient, encounter, cohort, institution, or clinical-workflow level by default. Treat cell-, patch-, specimen-, or molecular-level observations as nested measurements when they appear in multimodal data.

Produce research plans, analyses, code, evaluation artifacts, manuscripts, and figures. Do not diagnose, treat, triage, dose, or automate live patient-specific decisions.

## Invocation portability

Use `$clinical-ai-agent-research` in Codex and `/clinical-ai-agent-research` in Claude Code. When routing to a sibling skill, use the host's native invocation syntax: `$skill-name` in Codex or `/skill-name` in Claude Code.

## Safety gate

Before reading data or unpublished material:

1. Establish authorization, intended use, study population, setting, and output audience.
2. Classify inputs as public, synthetic, aggregate, de-identified/pseudonymized row-level, PHI, confidential manuscript, or proprietary.
3. Keep PHI and confidential clinical data out of prompts and external services. Process authorized row-level data locally with code; expose only the minimum schema or aggregate diagnostics needed for reasoning.
4. Do not send unpublished manuscripts, model details, patient data, images, waveforms, or omics data to external search, LLM, image, telemetry, or hosted RAG services without explicit authorization and policy review.
5. Mark all clinical outputs as research-only drafts requiring qualified human review.

For patient-specific care requests, stop and direct the user to an appropriately licensed professional and locally validated clinical system.

## Route to installed skills

Use the smallest relevant subset. Load every selected sibling Skill before acting.

| Need | Preferred Skill |
|---|---|
| Reproducible literature retrieval | `paper-lookup` |
| Study design and randomization | `experimental-design` |
| Clinical model evaluation and governance artifacts | `clinical-decision-support` |
| Classical prediction, preprocessing, pipelines | `scikit-learn` |
| Deep and multimodal model training | `pytorch-lightning` |
| Statistical tests, effect sizes, power, uncertainty | `statistical-analysis` |
| General agent/tool workflows | `langchain` |
| Document, evidence, multimodal RAG | `llamaindex` |
| Role-based multi-agent prototypes | `crewai-multi-agent` |
| LLM benchmark evaluation | `evaluating-llms-harness` |
| Medical/scientific manuscript work | `scientific-writing` |
| NeurIPS, ICML, ICLR, ACL, AAAI, or COLM paper work | `ml-paper-writing` |
| Confidential manuscript critique | `peer-review` |
| Journal-grade data figures | `scientific-visualization` |
| ML-conference plots and architecture figures | `academic-plotting` |

Do not use an agent framework merely because the project mentions agents. First define the task, baseline, interfaces, evaluation set, and failure policy.

## Core workflow

### 1. Freeze the research question

Write a one-page research contract before modeling:

- clinical problem and intended decision support role;
- population, setting, unit of analysis, index time, prediction horizon, and outcome;
- diagnostic, prognostic, treatment-effect, workflow, retrieval, or agent task;
- development, internal validation, external validation, or prospective evaluation stage;
- comparator, baseline, primary metric, subgroup plan, and success/failure criteria;
- data sources, modalities, authorization, provenance, and missingness.

Use PICOTS when it fits. Do not let model availability redefine the clinical question.

### 2. Define the data hierarchy and split

Declare every nesting level, for example:

`site → patient → encounter → study/specimen → image/assay → patch/cell`

Assign the highest leakage-relevant unit to one split before preprocessing, feature selection, augmentation, imputation, normalization, or embedding. Prefer:

1. external site or cohort validation;
2. temporal validation;
3. grouped patient-level validation;
4. nested cross-validation for development choices.

Never randomly split encounters, images, patches, cells, augmented samples, or report fragments from the same patient across train and test.

Read [multimodal-and-agent-evaluation.md](references/multimodal-and-agent-evaluation.md) for modality and multi-agent rules.

### 3. Build meaningful baselines

Include, as applicable:

- clinical standard of care or existing score;
- transparent logistic/Cox model;
- simple tree or gradient-boosted baseline;
- unimodal baselines;
- single-agent and no-tool baselines;
- retrieval-only or deterministic workflow baseline.

Add complexity only when it improves a prespecified outcome under fair evaluation.

### 4. Evaluate beyond headline accuracy

For clinical prediction, report discrimination, calibration, uncertainty, threshold-specific performance, clinical utility, subgroup behavior, missing-modality behavior, and external validity. For agents, also report task success, unsupported claims, tool errors, recovery, consistency, latency, cost, and auditability.

Do not select thresholds on the final test set. Do not describe internal cross-validation as external validation.

Read [clinical-evaluation.md](references/clinical-evaluation.md) before designing or auditing a prediction study.

### 5. Report and visualize

Choose the applicable current guideline and verify its official live version. Treat a reporting checklist as a transparency aid, not proof of methodological quality.

Use local deterministic plotting for quantitative results. For confidential or unpublished architectures, use local SVG, Mermaid, Graphviz, TikZ, or editable slide shapes; do not use the external Gemini path in `academic-plotting`.

Read [reporting-and-figures.md](references/reporting-and-figures.md) before manuscript or figure work.

## Cell and omics branch

Do not install or load cell-specific tooling merely because cellular data might appear later.

When actual data arrives, identify its representation:

- single-cell matrix or AnnData: consider `anndata`/`scanpy`;
- digital pathology WSI or tiles: consider `pathml` or a lighter histology tool;
- molecular or drug features: consider `deepchem`;
- derived cell counts, proportions, or embeddings: usually treat them as patient/specimen-level features with hierarchical validation.

Ask before adding a specialized Skill. Preserve the patient/specimen grouping, batch structure, assay provenance, and biological replicate definition.

## Required handoff

For substantial work, return:

1. research contract and assumptions;
2. data hierarchy and leakage-safe split plan;
3. baseline and ablation matrix;
4. evaluation table with uncertainty and subgroup fields;
5. privacy, safety, and external-service decisions;
6. reporting guideline and target venue;
7. figure plan and reproducibility manifest;
8. unresolved risks requiring clinician, statistician, ethics, privacy, or regulatory review.
