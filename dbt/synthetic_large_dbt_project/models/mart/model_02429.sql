{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01692') }},
        {{ ref('model_02143') }}
)
select id, 'model_02429' as name from sources
