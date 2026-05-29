{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00589') }},
        {{ ref('model_00100') }},
        {{ ref('model_00435') }}
)
select id, 'model_01001' as name from sources
