{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00787') }},
        {{ ref('model_01249') }}
)
select id, 'model_01511' as name from sources
