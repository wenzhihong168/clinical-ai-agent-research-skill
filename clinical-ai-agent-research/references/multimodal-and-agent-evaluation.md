# Multimodal and multi-agent evaluation

## Contents

1. Multimodal data
2. Optional cellular modalities
3. Multi-agent design
4. Multi-agent evaluation

## 1. Multimodal data

Create a modality contract for EHR/tabular data, notes, images, waveforms, signals, genomics/omics, cell-derived measurements, and external knowledge:

- acquisition time relative to the index time;
- unit and nesting level;
- availability at intended use;
- missingness mechanism and missing-modality policy;
- preprocessing and provenance;
- alignment key and permissible linkage;
- fusion strategy: early, late, hybrid, or decision-level;
- train/validation/test isolation.

Build unimodal baselines and modality-ablation experiments. Test complete-case performance separately from real-world missing-modality performance. Never let a future note, report, pathology result, or post-outcome intervention leak into an earlier prediction.

## 2. Optional cellular modalities

Map cell data to:

`patient → specimen → assay/slide → region/cluster → cell`

Do not treat cells as independent patients. Random cell-level splitting can produce severe identity, batch, and specimen leakage.

Depending on the scientific question:

- aggregate validated cell features to specimen or patient level;
- use hierarchical or multiple-instance models;
- retain patient/specimen grouping in every resampling step;
- model batch, site, platform, and assay effects;
- distinguish biological replicates from technical replicates.

Load a specialized cell, pathology, or molecular Skill only after the file format and scientific role are known.

## 3. Multi-agent design

Define each agent by:

- bounded role and permitted evidence;
- tool allowlist and data access;
- input/output schema;
- shared versus private state;
- handoff and arbitration rule;
- timeout, retry, and stop condition;
- provenance and audit record;
- human escalation boundary.

Use deterministic code for calculations, database operations, and validation. Use agents for interpretation, decomposition, retrieval planning, critique, and synthesis.

## 4. Multi-agent evaluation

Compare:

1. deterministic or non-agent baseline;
2. single-agent baseline;
3. multi-agent system;
4. agent, tool, memory, retrieval, and verifier ablations.

Measure:

- task correctness and clinically important error classes;
- unsupported or contradicted claims;
- retrieval precision, recall, and citation validity;
- tool-call validity and recovery from tool failure;
- inter-run consistency across fixed evaluation cases and seeds;
- subgroup/site/modality behavior;
- prompt-injection and untrusted-document resistance;
- human override, escalation, and abstention behavior;
- latency, token/tool cost, and operational complexity;
- completeness of the audit trail.

Use a frozen evaluation set and a separate development set. Do not tune prompts, routing, or agent roles on the final evaluation cases.
