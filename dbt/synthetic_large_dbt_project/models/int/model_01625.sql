{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01178') }},
        {{ ref('model_01086') }}
)
select id, 'model_01625' as name from sources
