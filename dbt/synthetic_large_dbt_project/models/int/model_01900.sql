{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00863') }},
        {{ ref('model_00909') }}
)
select id, 'model_01900' as name from sources
