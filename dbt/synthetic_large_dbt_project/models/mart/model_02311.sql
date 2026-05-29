{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01580') }},
        {{ ref('model_02146') }},
        {{ ref('model_01998') }}
)
select id, 'model_02311' as name from sources
