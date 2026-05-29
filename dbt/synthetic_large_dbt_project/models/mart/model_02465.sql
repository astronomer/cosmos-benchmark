{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01548') }},
        {{ ref('model_01832') }}
)
select id, 'model_02465' as name from sources
