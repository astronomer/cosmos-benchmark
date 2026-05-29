{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01865') }},
        {{ ref('model_01846') }}
)
select id, 'model_02633' as name from sources
