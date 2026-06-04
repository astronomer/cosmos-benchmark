{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01490') }},
        {{ ref('model_00969') }},
        {{ ref('model_00753') }}
)
select id, 'model_02178' as name from sources
