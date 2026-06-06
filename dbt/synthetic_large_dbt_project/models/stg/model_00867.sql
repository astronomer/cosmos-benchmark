{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00187') }},
        {{ ref('model_00696') }},
        {{ ref('model_00343') }}
)
select id, 'model_00867' as name from sources
