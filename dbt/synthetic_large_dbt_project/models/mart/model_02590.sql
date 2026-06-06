{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02192') }},
        {{ ref('model_02106') }},
        {{ ref('model_01562') }}
)
select id, 'model_02590' as name from sources
