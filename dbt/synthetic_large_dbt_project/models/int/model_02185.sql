{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01365') }},
        {{ ref('model_01171') }}
)
select id, 'model_02185' as name from sources
