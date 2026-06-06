{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00415') }},
        {{ ref('model_00613') }},
        {{ ref('model_00577') }}
)
select id, 'model_00991' as name from sources
