{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01265') }},
        {{ ref('model_01451') }}
)
select id, 'model_02054' as name from sources
