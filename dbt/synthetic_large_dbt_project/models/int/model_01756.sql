{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01492') }},
        {{ ref('model_01140') }},
        {{ ref('model_01419') }}
)
select id, 'model_01756' as name from sources
