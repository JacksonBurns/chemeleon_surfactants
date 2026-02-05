SEEDS=(42 104 2022 2024 4592)
DATASETS=(1 2)
OUTFILE="chemeleon_test_metrics.csv"

echo "dataset,seed,rmse,r2,mse,mae" > "${OUTFILE}"

for seed in "${SEEDS[@]}"; do
    for dataset in "${DATASETS[@]}"; do

        OUTDIR="data${dataset}_seed_${seed}_results"
        LOGFILE="${OUTDIR}/log.txt"

        chemprop train \
            --output-dir "${OUTDIR}" \
            --logfile "${LOGFILE}" \
            --data-path \
                "data${dataset}/${seed}_fold_0_train.csv" \
                "data${dataset}/${seed}_fold_0_valid.csv" \
                "data${dataset}/${seed}_fold_0_test.csv" \
            --from-foundation CheMeleon \
            --pytorch-seed 42 \
            --smiles-columns smiles \
            --target-columns logCMC \
            --task-type regression \
            --patience 5 \
            --loss mse \
            --metrics rmse r2 mse mae \
            --show-individual-scores \
            --ffn-num-layers 1 \
            --ffn-hidden-dim 2048 \
            --batch-size 32 \
            --epochs 50

        awk -v dataset="${dataset}" -v seed="${seed}" '
            /test\/logCMC\/rmse:/ { rmse=$NF }
            /test\/logCMC\/r2:/   { r2=$NF }
            /test\/logCMC\/mse:/  { mse=$NF }
            /test\/logCMC\/mae:/  { mae=$NF }
            END {
                if (rmse && r2 && mse && mae)
                    printf "%s,%s,%s,%s,%s,%s\n",
                           dataset, seed, rmse, r2, mse, mae
                else
                    printf "WARN: Missing metrics for dataset=%s seed=%s\n",
                           dataset, seed > "/dev/stderr"
            }
        ' "${LOGFILE}" >> "${OUTFILE}"

    done
done

