{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00705') }},
        {{ ref('model_00092') }},
        {{ ref('model_00291') }}
)
select id, 'model_00853' as name from sources
