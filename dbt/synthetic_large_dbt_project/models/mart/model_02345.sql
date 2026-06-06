{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01659') }},
        {{ ref('model_02101') }},
        {{ ref('model_02013') }}
)
select id, 'model_02345' as name from sources
