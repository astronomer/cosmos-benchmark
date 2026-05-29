{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01807') }},
        {{ ref('model_01734') }},
        {{ ref('model_02218') }}
)
select id, 'model_02408' as name from sources
