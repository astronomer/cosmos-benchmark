{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00953') }},
        {{ ref('model_00863') }},
        {{ ref('model_00944') }}
)
select id, 'model_01828' as name from sources
