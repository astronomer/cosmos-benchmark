{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01406') }},
        {{ ref('model_00874') }}
)
select id, 'model_02001' as name from sources
