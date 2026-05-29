{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01125') }},
        {{ ref('model_01278') }},
        {{ ref('model_00764') }}
)
select id, 'model_02247' as name from sources
