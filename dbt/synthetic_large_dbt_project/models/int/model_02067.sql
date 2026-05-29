{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00876') }},
        {{ ref('model_01192') }},
        {{ ref('model_00899') }}
)
select id, 'model_02067' as name from sources
