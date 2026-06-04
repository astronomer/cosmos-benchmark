{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00319') }},
        {{ ref('model_00023') }},
        {{ ref('model_00591') }}
)
select id, 'model_01202' as name from sources
