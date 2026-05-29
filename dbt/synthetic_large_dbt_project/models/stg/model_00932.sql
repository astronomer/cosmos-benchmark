{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00575') }},
        {{ ref('model_00229') }},
        {{ ref('model_00662') }}
)
select id, 'model_00932' as name from sources
