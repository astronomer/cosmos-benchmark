{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00980') }},
        {{ ref('model_00929') }},
        {{ ref('model_00826') }}
)
select id, 'model_01817' as name from sources
