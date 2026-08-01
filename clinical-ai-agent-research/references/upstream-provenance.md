# Upstream skill provenance

This orchestration skill assumes the following upstream skills are installed.
They were selected for broad clinical-AI, machine-learning, agent, writing, and
figure workflows while leaving cell-specific stacks optional.

## K-Dense-AI/scientific-agent-skills

- Repository: `https://github.com/K-Dense-AI/claude-scientific-skills`
- Installed from commit: `ab2f84ab10597c59fac186ecda6d5edd5dcc8b92`
- Skills:
  - `paper-lookup`
  - `scientific-writing`
  - `peer-review`
  - `statistical-analysis`
  - `scientific-visualization`
  - `clinical-decision-support`
  - `experimental-design`
  - `scikit-learn`
  - `pytorch-lightning`

## Orchestra-Research/AI-Research-SKILLs

- Repository: `https://github.com/Orchestra-Research/AI-Research-SKILLs`
- Installed from commit: `773a52944ba4747a18bd4ae9ade53fff041adcbc`
- Skills:
  - `ml-paper-writing`
  - `academic-plotting`
  - `langchain`
  - `llamaindex`
  - `crewai-multi-agent` (source directory: `crewai`)
  - `evaluating-llms-harness` (source directory: `lm-evaluation-harness`)

## Deliberately optional

Do not install or invoke `scanpy`, `pathml`, `deepchem`, or other cell- and
molecule-heavy stacks by default. Add one only after confirming the actual data
type, storage format, analysis unit, and validation hierarchy.

Upstream repositories evolve. Before updating any installed copy, inspect its
current license, permissions, scripts, network behavior, and dependency changes,
then pin the reviewed commit rather than following an unreviewed moving branch.
