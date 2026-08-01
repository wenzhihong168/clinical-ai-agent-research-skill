# Reporting and figures

## Venue routing

- Medical or interdisciplinary journal: use `$scientific-writing`, `$peer-review`, and `$scientific-visualization`.
- NeurIPS, ICML, ICLR, ACL, AAAI, or COLM: use `$ml-paper-writing`, `$academic-plotting`, and `$scientific-visualization`.
- Clinical prediction study: add the applicable current TRIPOD+AI, PROBAST+AI, or STARD-AI workflow.
- Early live decision-support evaluation: consider DECIDE-AI and the study-design-specific guideline.

Always verify the target venue's current official author, figure, disclosure, and AI-use rules.

## Figure plan

Use a reproducible source table and script for every quantitative figure. Prefer:

- cohort flow diagram;
- data hierarchy and split diagram;
- model or multi-agent architecture;
- ROC and precision-recall plots;
- calibration plot and decision curve;
- subgroup/forest plot with uncertainty;
- temporal or external validation comparison;
- modality and agent ablation;
- failure-mode or confusion analysis;
- latency/cost/quality trade-off when agent systems are evaluated.

## Integrity and export

- Show raw observations when feasible and define uncertainty.
- Preserve missingness, denominators, exclusions, transformations, and seeds.
- Use consistent axes across comparable panels.
- Use color plus shape, line style, hatching, or direct labels.
- Prefer vector PDF/SVG for plots and diagrams; use TIFF/PNG only when raster is appropriate.
- Inspect physical dimensions, embedded fonts, clipping, contrast, and effective raster resolution after export.
- Generate confidential architecture diagrams locally. Do not send unpublished methods or clinical content to external image APIs.
- Never use generative imagery for quantitative data or to imply observations that were not measured.

## Reproducibility manifest

Record:

- input data identifiers and versions;
- analysis and plotting code paths;
- environment or lockfile;
- random seeds;
- transformations and exclusions;
- figure dimensions, formats, and source tables;
- target venue and date its official requirements were checked.
