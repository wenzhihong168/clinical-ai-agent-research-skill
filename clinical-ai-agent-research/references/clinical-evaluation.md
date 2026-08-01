# Clinical prediction evaluation

## Contents

1. Study contract
2. Leakage and validation
3. Metrics
4. Bias, fairness, and utility
5. Minimum audit

## 1. Study contract

Define before modeling:

- target population, care setting, index time, outcome, horizon, and intended users;
- whether the output is diagnostic classification, prognostic risk, treatment-effect estimation, ranking, retrieval, or workflow support;
- intended action and the consequence of false positives, false negatives, delay, and abstention;
- development versus internal, external, temporal, geographic, or prospective evaluation;
- source cohort, inclusion/exclusion, censoring, competing risks, missingness, and label process.

Prefer a clinically meaningful endpoint over a convenient proxy. Record label availability at the intended prediction time.

## 2. Leakage and validation

- Split by patient before any learned preprocessing.
- Use site and time splits when deployment across settings or time is claimed.
- Fit imputation, scaling, feature selection, calibration, embedding, and threshold selection on training data only.
- Use nested resampling when tuning and performance estimation would otherwise share folds.
- Keep repeated encounters and every derived modality from one patient in one split.
- Keep cell, patch, tile, specimen, augmentation, and report fragments nested under their originating patient or specimen.
- Report cohort flow and attrition for every split.
- Do not call random held-out data from the same source an external validation cohort.

## 3. Metrics

Select metrics from the intended use:

- discrimination: AUROC plus AUPRC when prevalence or imbalance matters;
- threshold performance: sensitivity, specificity, PPV, NPV, likelihood ratios, confusion counts, and coverage/abstention;
- calibration: calibration plot, intercept, slope, observed-to-expected ratio, and Brier score where appropriate;
- clinical utility: decision-curve analysis or another justified utility analysis over prespecified thresholds;
- survival: time-dependent discrimination and calibration with censoring handled explicitly;
- uncertainty: confidence or credible intervals with the resampling unit matching the independent unit;
- subgroup and shift: performance and calibration across prespecified clinically relevant groups, sites, devices, time, and missing modalities.

Report prevalence and the threshold selection rule. Avoid accuracy as the only metric.

## 4. Bias, fairness, and utility

- Compare against standard care and a transparent statistical baseline.
- Assess whether predictors are available, measured, and stable at the index time.
- Separate model-development quality from evaluation risk of bias.
- Prespecify subgroup analyses and distinguish fairness exploration from validated mitigation.
- Evaluate missing-modality and out-of-distribution behavior.
- State whether recalibration, updating, monitoring, or abstention is required.
- Do not infer clinical benefit from retrospective predictive performance alone.

## 5. Minimum audit

Check the current official versions and scopes of:

- TRIPOD+AI for reporting clinical prediction model development/evaluation;
- PROBAST+AI for quality, risk of bias, and applicability;
- STARD-AI for AI diagnostic-accuracy studies;
- DECIDE-AI for early live clinical evaluation of AI decision support;
- CONSORT-AI/SPIRIT-AI for randomized trials and protocols;
- CLAIM for medical-imaging AI when applicable.

Verify the target journal's current author instructions and AI-use policy immediately before submission.
