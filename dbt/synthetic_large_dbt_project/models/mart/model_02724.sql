{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02066') }},
        {{ ref('model_01828') }},
        {{ ref('model_01709') }}
)
select id, 'model_02724' as name from sources
