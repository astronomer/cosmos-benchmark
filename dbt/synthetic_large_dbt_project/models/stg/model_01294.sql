{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00535') }},
        {{ ref('model_00461') }}
)
select id, 'model_01294' as name from sources
