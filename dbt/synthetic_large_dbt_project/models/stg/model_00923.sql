{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00463') }},
        {{ ref('model_00136') }}
)
select id, 'model_00923' as name from sources
