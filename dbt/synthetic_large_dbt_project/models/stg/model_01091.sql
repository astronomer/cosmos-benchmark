{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00189') }},
        {{ ref('model_00019') }},
        {{ ref('model_00634') }}
)
select id, 'model_01091' as name from sources
