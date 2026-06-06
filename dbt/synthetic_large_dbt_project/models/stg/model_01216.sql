{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00731') }},
        {{ ref('model_00109') }}
)
select id, 'model_01216' as name from sources
