{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02074') }},
        {{ ref('model_01619') }},
        {{ ref('model_02107') }}
)
select id, 'model_02854' as name from sources
