{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00440') }},
        {{ ref('model_00331') }}
)
select id, 'model_01123' as name from sources
