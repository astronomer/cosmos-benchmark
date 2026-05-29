{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00496') }},
        {{ ref('model_00523') }}
)
select id, 'model_01398' as name from sources
