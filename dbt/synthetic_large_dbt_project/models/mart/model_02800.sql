{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01741') }},
        {{ ref('model_01998') }}
)
select id, 'model_02800' as name from sources
