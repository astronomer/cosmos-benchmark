{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01607') }},
        {{ ref('model_01786') }},
        {{ ref('model_02241') }}
)
select id, 'model_02454' as name from sources
