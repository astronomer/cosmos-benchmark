{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00288') }},
        {{ ref('model_00381') }},
        {{ ref('model_00496') }}
)
select id, 'model_01370' as name from sources
