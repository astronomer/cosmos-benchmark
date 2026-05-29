{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00416') }},
        {{ ref('model_00223') }},
        {{ ref('model_00135') }}
)
select id, 'model_01316' as name from sources
