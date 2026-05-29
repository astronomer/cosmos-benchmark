{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00148') }},
        {{ ref('model_00371') }}
)
select id, 'model_01441' as name from sources
