{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00349') }},
        {{ ref('model_00389') }},
        {{ ref('model_00099') }}
)
select id, 'model_01411' as name from sources
