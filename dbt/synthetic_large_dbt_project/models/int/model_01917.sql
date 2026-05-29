{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00914') }},
        {{ ref('model_01263') }},
        {{ ref('model_01278') }}
)
select id, 'model_01917' as name from sources
