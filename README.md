# CheMeleon Surfactants

This repository demonstrates the use of `CheMeleon` to model surfactant critical micelle concentration (CMC, specifically $log_{10}$ of CMC).
This challenging property is beyond the scope of benchmarks for which `CheMeleon` was originally tested, so it's a great way to evaluate how well it works out of its typical domain.

## Running

The only dependency for this quick demo is `chemprop>=2.2.2`, which you can install with `pip`, `conda`, or Docker.
You do specifically need version 2.2.2 and not any earlier version, since this demo relies on a new feature: the ability to pass a custom training, validation, and testing set via the command line interface (`chemprop train --input-data train.csv val.csv test.csv ...`).
This won't work on earlier versions of Chemprop, but could be achieved using the Python API.

To run `CheMeleon`, simply run `. train.sh`.
I originally developed this script using BASH on Ubuntu, so you might need to adapt it a bit for your shell and operating system.

## References

The authors have produced a manuscript about this topic here: [10.1016/j.commatsci.2026.114548](https://doi.org/10.1016/j.commatsci.2026.114548)
You can find the source code and data (`data1` and `data2`, duplicated here) for the original study at [Graph-transformers-GCN-GAT/GCN-GAT-PharmaHGT](https://github.com/Graph-transformers-GCN-GAT/GCN-GAT-PharmaHGT) - huge thanks to the study authors for making their data public and so easily accessible!

You can read more about `CheMeleon` at its GitHub repository [`JacksonBurns/CheMeleon`](https://github.com/jacksonburns/chemeleon) and corresponding [`paper`](https://doi.org/10.48550/arXiv.2506.15792).

## Results

Below is a table showing the test performance (averaged across the five repetitions) for the three best models in the original study, as well as `CheMeleon`, for `data1` and `data2`:

| Model       | R² (`data1`) | RMSE (`data1`) | MAE (`data1`) | R² (`data2`) | RMSE (`data2`) | MAE (`data2`) |
|-------------|--------------|----------------|---------------|--------------|----------------|---------------|
| GAT         | 0.845 | 0.560 | 0.369  | 0.765 | 0.564 | 0.369 |
| GCN         | 0.883 | 0.487 | 0.340  | 0.907 | 0.182 | 0.307 |
| PharmHGT    | 0.941 | 0.304 | 0.217  | 0.947 | 0.283 | 0.224 |
| `CheMeleon` | 0.924 | 0.367 | 0.267  | 0.877 | 0.432 | 0.300 |

`CheMeleon` does pretty good!
It surpasses the GAT and GCN models on the easier `data1` dataset, and gets close to the performance of the best PharmHGT model in the lead metric R²: 0.924 vs 0.941.
This is also without any hyperparameter optimization, just simple one-shot tuning of the `CheMeleon` foundation model.

On the `data2` dataset, which is more challenging, PharmHGT establishes a more convincing lead with an R² of 0.947.
`CheMeleon` is on par with the GCN model included in the original study, with R² of 0.877 and 0.907, respectively.

Taken together, these results perfectly encapsulate the "accuracy-effort tradeoff" of `CheMeleon`.
It meets or exceeds the performance of conventional machine learning baselines, and can even come close to a specialized state-of-the-art model, no hyperparameter tuning required, and all in one command line interface call.
This doesn't mean it can entirely replace these models, especially given that PharmHGT can do structural attributions that are challenging for Chemprop-based models.

Note on statistics: `CheMeleon`'s R² is _actually_ 0.924 $\pm$ 0.013 for `data1` and 0.877 $\pm$ 0.050 for `data2`.
If we optimistically assume that PharmHGT has _zero_ variance across the replicates, a paired t-test (comparing only these two models!) would give a $p$ value a bit below 0.05, indicating a statistically significant improvement.
Looking in the Supporting Information, we can see that for RMSE PharmHGT has a comparable standard deviation to `CheMeleon` across the 5 seeds.
Without the exact numbers we can't make any claims, but the performance of the two models is _very_ similar!
