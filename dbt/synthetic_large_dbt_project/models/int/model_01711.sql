{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00959') }},
        {{ ref('model_00991') }},
        {{ ref('model_01269') }}
)
select id, 'model_01711' as name from sources
