{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00072') }},
        {{ ref('model_00560') }},
        {{ ref('model_00616') }}
)
select id, 'model_01485' as name from sources
