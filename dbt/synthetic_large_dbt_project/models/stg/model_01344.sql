{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00296') }},
        {{ ref('model_00587') }}
)
select id, 'model_01344' as name from sources
