{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00763') }},
        {{ ref('model_01449') }},
        {{ ref('model_01315') }}
)
select id, 'model_01846' as name from sources
