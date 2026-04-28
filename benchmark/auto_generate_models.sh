#!/usr/bin/env bash
set -euo pipefail

: "${1:?Usage: $0 <number_of_copies>}"

slow_models=(
    "dbt/altered_jaffle_shop/models/customers_slow_query.sql"
    "dbt/altered_jaffle_shop/models/long_model_cross_random.sql"
    "dbt/altered_jaffle_shop/models/long_model_subquery_windows.sql"
    "dbt/altered_jaffle_shop/models/long_model_text_processing.sql"
)

for file in "${slow_models[@]}"; do
    for ((i = 1; i <= $1; i++)); do
        cp -n "$file" "${file%.sql}${i}.sql"
    done
done
