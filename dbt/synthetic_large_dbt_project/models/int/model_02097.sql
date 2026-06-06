{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00810') }},
        {{ ref('model_00892') }}
)
select id, 'model_02097' as name from sources
