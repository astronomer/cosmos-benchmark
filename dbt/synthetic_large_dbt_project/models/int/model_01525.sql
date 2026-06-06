{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01218') }},
        {{ ref('model_00863') }}
)
select id, 'model_01525' as name from sources
