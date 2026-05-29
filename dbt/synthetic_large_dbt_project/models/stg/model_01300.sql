{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00291') }},
        {{ ref('model_00214') }}
)
select id, 'model_01300' as name from sources
