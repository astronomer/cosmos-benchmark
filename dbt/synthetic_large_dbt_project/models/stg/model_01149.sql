{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00026') }},
        {{ ref('model_00367') }},
        {{ ref('model_00081') }}
)
select id, 'model_01149' as name from sources
