{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00691') }},
        {{ ref('model_00490') }}
)
select id, 'model_00988' as name from sources
