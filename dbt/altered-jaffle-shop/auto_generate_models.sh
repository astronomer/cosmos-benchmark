slow_models=(
    "models/customers_slow_query.sql"
    "models/long_model_cross_random.sql"
    "models/long_model_subquery_windows.sql"
    "models/long_model_text_processing.sql"
)

for file in "${slow_models[@]}"; do
    for i in {1..30}; do
        cp "$file" "${file%.sql}${i}.sql"
    done
done
