{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00076') }},
        {{ ref('model_00740') }},
        {{ ref('model_00103') }}
)
select id, 'model_00892' as name from sources
