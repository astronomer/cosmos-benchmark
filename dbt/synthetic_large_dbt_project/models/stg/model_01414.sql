{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00333') }},
        {{ ref('model_00038') }},
        {{ ref('model_00471') }}
)
select id, 'model_01414' as name from sources
