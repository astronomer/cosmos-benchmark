{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00204') }},
        {{ ref('model_00501') }},
        {{ ref('model_00456') }}
)
select id, 'model_01489' as name from sources
