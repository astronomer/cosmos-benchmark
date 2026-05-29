{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00903') }},
        {{ ref('model_01140') }},
        {{ ref('model_01414') }}
)
select id, 'model_02142' as name from sources
