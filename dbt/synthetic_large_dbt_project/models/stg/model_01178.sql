{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00281') }},
        {{ ref('model_00337') }},
        {{ ref('model_00539') }}
)
select id, 'model_01178' as name from sources
