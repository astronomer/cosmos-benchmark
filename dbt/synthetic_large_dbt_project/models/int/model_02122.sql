{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00808') }},
        {{ ref('model_00861') }},
        {{ ref('model_01316') }}
)
select id, 'model_02122' as name from sources
