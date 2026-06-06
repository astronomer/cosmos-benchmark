{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00111') }},
        {{ ref('model_00462') }},
        {{ ref('model_00467') }}
)
select id, 'model_01156' as name from sources
