{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00307') }},
        {{ ref('model_00254') }},
        {{ ref('model_00535') }}
)
select id, 'model_01494' as name from sources
