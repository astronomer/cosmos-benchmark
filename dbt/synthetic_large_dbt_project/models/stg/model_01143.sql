{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00207') }},
        {{ ref('model_00141') }},
        {{ ref('model_00316') }}
)
select id, 'model_01143' as name from sources
