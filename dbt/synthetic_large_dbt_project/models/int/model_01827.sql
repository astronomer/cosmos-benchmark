{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00915') }},
        {{ ref('model_00893') }}
)
select id, 'model_01827' as name from sources
