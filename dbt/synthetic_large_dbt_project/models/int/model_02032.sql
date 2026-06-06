{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01265') }},
        {{ ref('model_00921') }},
        {{ ref('model_00900') }}
)
select id, 'model_02032' as name from sources
