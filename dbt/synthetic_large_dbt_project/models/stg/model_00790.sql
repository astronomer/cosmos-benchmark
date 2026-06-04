{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00086') }},
        {{ ref('model_00596') }},
        {{ ref('model_00600') }}
)
select id, 'model_00790' as name from sources
