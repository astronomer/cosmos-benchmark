{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01155') }},
        {{ ref('model_01485') }},
        {{ ref('model_00984') }}
)
select id, 'model_02193' as name from sources
