{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01815') }},
        {{ ref('model_01921') }}
)
select id, 'model_02954' as name from sources
