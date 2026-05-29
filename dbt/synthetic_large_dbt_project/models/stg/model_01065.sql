{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00611') }},
        {{ ref('model_00236') }}
)
select id, 'model_01065' as name from sources
