{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02202') }},
        {{ ref('model_01878') }},
        {{ ref('model_01758') }}
)
select id, 'model_02293' as name from sources
