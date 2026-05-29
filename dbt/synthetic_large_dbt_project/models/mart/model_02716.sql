{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01810') }},
        {{ ref('model_02048') }}
)
select id, 'model_02716' as name from sources
