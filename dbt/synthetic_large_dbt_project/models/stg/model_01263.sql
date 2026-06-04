{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00653') }},
        {{ ref('model_00124') }},
        {{ ref('model_00725') }}
)
select id, 'model_01263' as name from sources
