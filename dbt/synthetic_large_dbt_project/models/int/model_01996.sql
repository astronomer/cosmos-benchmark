{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00992') }},
        {{ ref('model_01340') }}
)
select id, 'model_01996' as name from sources
