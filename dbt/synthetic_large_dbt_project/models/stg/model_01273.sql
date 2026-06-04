{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00446') }},
        {{ ref('model_00413') }}
)
select id, 'model_01273' as name from sources
