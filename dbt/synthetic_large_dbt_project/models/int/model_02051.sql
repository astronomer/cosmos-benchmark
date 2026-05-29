{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01342') }},
        {{ ref('model_00892') }}
)
select id, 'model_02051' as name from sources
