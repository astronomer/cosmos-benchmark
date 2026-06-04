{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00408') }},
        {{ ref('model_00268') }},
        {{ ref('model_00087') }}
)
select id, 'model_01120' as name from sources
