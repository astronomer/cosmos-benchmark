{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00454') }},
        {{ ref('model_00131') }},
        {{ ref('model_00094') }}
)
select id, 'model_00791' as name from sources
