{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00710') }},
        {{ ref('model_00009') }},
        {{ ref('model_00343') }}
)
select id, 'model_00776' as name from sources
