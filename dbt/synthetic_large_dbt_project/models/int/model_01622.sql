{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01322') }},
        {{ ref('model_00805') }},
        {{ ref('model_01182') }}
)
select id, 'model_01622' as name from sources
