{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00777') }},
        {{ ref('model_00941') }}
)
select id, 'model_01666' as name from sources
