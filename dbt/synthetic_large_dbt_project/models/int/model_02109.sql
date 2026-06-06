{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01420') }},
        {{ ref('model_01000') }},
        {{ ref('model_01049') }}
)
select id, 'model_02109' as name from sources
