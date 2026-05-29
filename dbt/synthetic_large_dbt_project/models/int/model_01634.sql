{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00965') }},
        {{ ref('model_01062') }}
)
select id, 'model_01634' as name from sources
