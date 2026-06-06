{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00854') }},
        {{ ref('model_01263') }},
        {{ ref('model_01157') }}
)
select id, 'model_02195' as name from sources
