{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00610') }},
        {{ ref('model_00158') }},
        {{ ref('model_00380') }}
)
select id, 'model_01083' as name from sources
