{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00121') }},
        {{ ref('model_00188') }},
        {{ ref('model_00325') }}
)
select id, 'model_01145' as name from sources
